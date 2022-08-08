const axios = require("axios");
const fs = require('fs');
const http = require("http");
const nodemailer = require('nodemailer');
const express = require('express');
const delay = time => new Promise(res=>setTimeout(res,time));

const rescanInterval = 24 * 60 * 60 * 1000;

process.on('uncaughtException', function (err) {
    console.log('catched uncaughtException', err)
});

const app = express();

let transporter = nodemailer.createTransport({ host: 'smtp.gmail.com',	port: 465,
	auth: {	 user: "vprihogenko@gmail.com",	 pass: "bkpsrboomrlyotgq" },
    //tls: {rejectUnauthorized: false}
});

let checkingEmailObj = {};
let usersObj = {};
let wantedList = [];

tryRestoryWorkingObjects();

_checkSearches();
setTimeout(_checkSearches, rescanInterval);

httpServer = http.createServer(app).listen(6635);
console.log('http: 6635');

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use(function (req, res, next) {
    console.log('\n\nInc Req at', req.hostname, 'url', req.url, 'method', req.method, new Date());
    console.log('host', req.headers.host); 
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "*");
    return next();
});

app.post('/checkEmail', (req, res)=>{
    console.log('/checkEmail req with', req.body);
    checkEmail(req.body, res);		
});

app.post('/addEmail', (req, res)=>{
    console.log('/addEmail req with', req.body);
    addEmail(req.body, res);		
});

app.post('/addSearch', (req, res)=>{
    console.log('/addSearch req with', req.body);
    addSearch(req.body, res);		
});

app.post('/editSearch', (req, res)=>{
    console.log('/editSearch req with', req.body);
    editSearch(req.body, res);		
});

app.post('/delSearch', (req, res)=>{
    console.log('/delSearch req with', req.body);
    delSearch(req.body, res);		
});

app.post('/getSearchList', (req, res)=>{
    console.log('/getSearchList req with', req.body);
    getSearchList(req.body, res);		
});

// -------------------------------------------------------------------------

async function getSearchList(body, res) { 
    let email = body.email;
    if (!email) { 
        console.log('no email');
        res.status(203).send('wrong parameters');
        return;
    }

    let code = body.code;
    if (!code) { 
        console.log('no code to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let savedCode = usersObj[email].code;
    if (code != savedCode) { 
        console.log('incorrect code', code, 'saved', savedCode);
        res.status(203).send('wrong code');
        return;
    }

    let resultList = [];
    wantedList.forEach(el => { 
        if (el.email == email) { 
            resultList.push(el);
        }
    });

    console.log('found', wantedList.length);

    res.status(200).send(JSON.stringify(resultList));
}

async function delSearch(body, res) { 
    let id = body.id;
    if (!id) { 
        console.log('no id');
        res.status(203).send('wrong parameters');
        return;
    }

    let searchIdx = wantedList.findIndex(s => s.id == id);
    if (searchIdx == -1) { 
        console.log('id ot found');
        res.status(203).send('id not found');
        return;
    }

    wantedList.splice(searchIdx, 1);
    console.log('wantedList element removed');

    saveWorkingObjects(2);

    res.status(200).send('ok');
}

async function editSearch(body, res) { 
    let id = body.id;
    if (!id) { 
        console.log('no id');
        res.status(203).send('wrong parameters');
        return;
    }

    let searchIdx = wantedList.findIndex(s => s.id == id);
    if (searchIdx == -1) { 
        console.log('id not found');
        res.status(203).send('id not found');
        return;
    }

    let email = body.email;
    if (!email || email.indexOf('@') == -1) { 
        console.log('no email to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let code = body.code;
    if (!code) { 
        console.log('no code to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let savedCode = usersObj[email].code;
    if (code != savedCode) { 
        console.log('incorrect code', code, 'saved', savedCode);
        res.status(203).send('wrong code');
        return;
    }

    let keywords = body.keywords.trim();
    if (!keywords || keywords.length < 5) { 
        console.log('no keywords to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let site = body.site ?? '';

    let search = {
        id,
        email,
        keywords,
        site
    };

    wantedList[searchIdx] = search;
    console.log('search updated', search);

    saveWorkingObjects(2);

    res.status(200).send('ok');

    let newLinks = await _getLast2daysNewsByKeyWords(search.keywords, search.site);
    fs.writeFileSync('tmp/' + search.id, JSON.stringify(newLinks));
    console.log('newLinks is saved', search.id);
}

async function addSearch(body, res) { 
    let email = body.email;
    if (!email || email.indexOf('@') == -1) { 
        console.log('no email to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let code = body.code;
    if (!code) { 
        console.log('no code to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let keywords = body.keywords.trim();
    if (!keywords || keywords.length < 5) { 
        console.log('no keywords to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let savedCode = usersObj[email].code;
    if (code != savedCode) { 
        console.log('incorrect code', code, 'saved', savedCode);
        res.status(203).send('wrong code');
        return;
    }

    let site = body.site ?? '';
    let id = ''+(1*(new Date()))+('' + Math.random()).substring(2);

    let search = {
        id,
        email,
        keywords,
        site
    };

    let similarIdx = wantedList.findIndex(s =>
        s.email == search.email && s.keywords == search.keywords && s.site == search.site
    );

    if (similarIdx > -1) { 
        console.log('duplicate');
        res.status(203).send('duplicate');
        return;
    }

    wantedList.push(search);
    console.log('new search added', search);

    saveWorkingObjects(2);

    res.status(200).send(id);

    let newLinks = await _getLast2daysNewsByKeyWords(search.keywords, search.site);
    fs.writeFileSync('tmp/' + search.id, JSON.stringify(newLinks));
    console.log('newLinks is saved', search.id);
}

async function addEmail(body, res) { 
    let email = body.email;
    if (!email || email.indexOf('@') == -1) { 
        console.log('no email to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let code = body.code;
    if (!code) { 
        console.log('no code to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let savedCode = checkingEmailObj[email].testCode;
    if (code != savedCode) { 
        console.log('incorrect code', code, 'saved', savedCode);
        res.status(203).send('wrong code');
        return;
    }

    console.log('checkingEmailObj1', checkingEmailObj);
    delete checkingEmailObj[email];
    console.log('checkingEmailObj2', checkingEmailObj);

    usersObj[email] = { code, name: body.name };
    saveWorkingObjects(1);

    res.status(200).send('ok');
}

async function checkEmail(body, res) { 
    let email = body.email;
    if (!email || email.indexOf('@') == -1) { 
        console.log('no email to check');
        res.status(203).send('wrong parameters');
        return;
    }

    let testCode = ('' + Math.random()).substring(3, 7);

    message = {
        from: "vprihogenko@gmail.com",
        to: email,
        subject: 'confirmation code',
        html: "<h3>"+'Hello. Your confirmation code is '+testCode+"</h3>",
    }
    if (await sendMail(message) == 0) { 
        console.log('err on email sending')
        res.status(203).send('err on email sending');
        return;
    }

    checkingEmailObj[email] = { dt: new Date(), testCode };
    console.log('email sent. checkingEmailObj', checkingEmailObj);

    res.status(200).send('ok');
}

function tryRestoryWorkingObjects() {
    try {
        usersObj = JSON.parse(fs.readFileSync('tmp/usersObj.json'));
    } catch (e) { }
    try {
        wantedList = JSON.parse(fs.readFileSync('tmp/wantedList.json'));
    } catch (e) { }
}

function saveWorkingObjects(mode) {
    if (mode == 1) {
        fs.writeFileSync('tmp/usersObj.json', JSON.stringify(usersObj));
        console.log('usersObj.json updated');
    } else if (mode == 2) { 
        fs.writeFileSync('tmp/wantedList.json', JSON.stringify(wantedList));	
        console.log('wantedList.json updated');	
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

async function _compareLinksAndEmailIfNeeded(oldLinks, newLinks, search) { 
    let linksToSend = [];
    newLinks.forEach(el => { 
        if (oldLinks.indexOf(el) == -1) { 
            linksToSend.push(el);
        }
    });
    console.log('got linksToSend', linksToSend.length);
    if (linksToSend.length > 0) { 
        console.log('sending email');
        let body = 'Hello. \nNew links available with your request of <<'+search.keywords+'>>';
        linksToSend.forEach(el => {
            body += '\n' + '<a href="'+el+'">'+el+'</a>';
        });
        message = {
            from: "vprihogenko@gmail.com",
            to: search.email,
            subject: 'News for '+search.keywords,
            html: body,
        }
        sendMail(message);
    }
}

async function _checkSearches() { 
    console.log('\n Start checkSearches', new Date());
    for (let idx = 0; idx < wantedList.length; idx++) {
        let search = wantedList[idx];
        let oldLinks = [];
        try {
            oldLinks = JSON.parse(fs.readFileSync('tmp/' + search.id));
            console.log('oldLinks', oldLinks);
        } catch (e) { }
        console.log('search', search);
        let newLinks = await _getLast2daysNewsByKeyWords(search.keywords, search.site);
        if (newLinks) {
            await _compareLinksAndEmailIfNeeded(oldLinks, newLinks, search);
            fs.writeFileSync('tmp/' + search.id, JSON.stringify(newLinks));
            console.log('newLinks is saved', search.id);
        }
        await delay(30*1000);
    }
    console.log('\n_checkSearches finished', new Date());
    setTimeout(_checkSearches, rescanInterval);
}

async function _getLast2daysNewsByKeyWords(keywords, site) { 
    console.log('_getLast2daysNewsByKeyWord with', keywords, 'site', site);
    let dtFrom = new Date(1 * (new Date()) - 2 * 24 * 60 * 60 * 1000);
    let month = dtFrom.getMonth()+1;
    let dtFromS = '' + dtFrom.getFullYear() + '/' + (month < 10 ? '0' : '') + month
        + '/' + (dtFrom.getDay() < 10 ? '0' : '') + dtFrom.getDay();
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

    let links = [];
    let isResult = false;
    let currentPage = 0; totalPages = 0;
    
    do {
        try {
            currentPage++;
            options.params.page = '' + currentPage;
            let result = await axios.request(options);
            console.log('result status', result.status);
            let data = result.data;
            if (data.status == 'ok') {
                totalPages = data.total_pages;
                let articles = data.articles;
                articles.forEach(a => {
                    links.push(a.link);
                });
                console.log('got links', links);
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

    console.log('isResult', isResult, links.length);

    if (isResult) { 
        return links;
    }
}