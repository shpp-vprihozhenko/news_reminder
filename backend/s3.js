const nodemailer = require('nodemailer');
let transporter = nodemailer.createTransport({ host: 'smtp.gmail.com',	port: 465,
	auth: {	 user: "vprihogenko@gmail.com",	 pass: "bkpsrboomrlyotgq" },
    //tls: {rejectUnauthorized: false}
});

checkEmail();

async function checkEmail() {
  let message = {
    from: "vprihogenko@gmail.com",
    to: 'test-3xk0dpvm6@srv1.mail-tester.com',
    subject: 'confirmation code',
    html: "<html><h3>" + 'Hello. Your confirmation code is ' + 2241 + "</h3></html>",
    text: 'Hello. Your confirmation code is ' + 2241,
  }
  if (await sendMail(message) == 0) {
    console.log('err on email sending')
  }
}

function sendMail(message) { 
  return new Promise((resolve, reject) => { 
      transporter.sendMail(message, (err, info) => {
          if (err) {
              console.log('err sendMail to', email, err)
              resolve(0);
          } else {
              console.log('email sent.');
              resolve(1);
          }
      });
  });
}

return;

//----------------------------------------

const axios = require("axios");
const e = require("express");

trySearch();

return;

//-------------------------------

async function trySearch() { 
  let news = await _getLast2daysNewsByKeyWords('никополь', '', 2);
  console.log('found news', news);
  let idx = news.findIndex(el => el.link == 'https://47news.ru/articles/216783');
  console.log('idx', idx);
}

async function _getLast2daysNewsByKeyWords(keywords, site, deepDays) { 
  console.log('_getLast2daysNewsByKeyWord with', keywords, 'site', site);
  let dtFrom = new Date(1 * (new Date()) - deepDays * 24 * 60 * 60 * 1000);
  let month = dtFrom.getMonth()+1;
  let dtFromS = '' + dtFrom.getFullYear() + '/' + (month < 10 ? '0' : '') + month
      + '/' + (dtFrom.getDate() < 10 ? '0' : '') + dtFrom.getDate();
  console.log('dtFromS', dtFromS);
  
  const options = {
      method: 'GET',
      url: 'https://newscatcher.p.rapidapi.com/v1/search_enterprise',
      params: {
        q: keywords,
        sort_by: 'relevancy',
        from: dtFromS,
        ranked_only: 'False',
        page: '1',
        page_size: '100',
        media: 'True'
      },
      headers: {
        'X-RapidAPI-Key': 'dd5c844ademsh435d59732eed2dep10bff5jsn350385712305',
        'X-RapidAPI-Host': 'newscatcher.p.rapidapi.com'
      }
  };
    
  if (site.length > 3) { 
      options.params.sources = site;
  }

  let news = [];
  let isResult = false;
  let currentPage = 0; totalPages = 0;
  
  do {
      try {
          currentPage++;
          options.params.page = '' + currentPage;
          let result = await axios.request(options);
          console.log('result status', currentPage, '=', result.status);
          let data = result.data;
          if (data.status == 'ok') {
              totalPages = data.total_pages;
              if (totalPages > 10) { 
                  totalPages = 10;
              }
              let articles = data.articles;
              articles.forEach(a => {
                  news.push({
                      link: a.link,
                      title: a.title
                  });
              });
              //console.log('got links', news);
              isResult = true;
          } else {
              console.log('got status', data.status);
              if (data.status == 'No matches for your search.') { 
                  console.log('empty');
                  isResult = true;
              }
          }
      } catch (e) {
          console.log('got err', e)
      }    
  } while (currentPage < totalPages);

  console.log('isResult', isResult, news.length);

  if (isResult) { 
      return news;
  }
}

// -------------------------------------------

const options = {
  method: 'GET',
  url: 'https://newscatcher.p.rapidapi.com/v1/search_enterprise',
  params: {
    q: 'нікополь',
    sort_by: 'relevancy',
    from: '2022/08/03',
    ranked_only: 'False',
    page: '1',
    page_size: '100',
    media: 'True'
  },
  headers: {
    'X-RapidAPI-Key': 'dd5c844ademsh435d59732eed2dep10bff5jsn350385712305',
    'X-RapidAPI-Host': 'newscatcher.p.rapidapi.com'
  }
};

axios.request(options).then(function (response) {
	console.log(response.data);
}).catch(function (error) {
	console.error(error);
});
