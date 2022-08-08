const axios = require("axios");

const options = {
  method: 'GET',
  url: 'https://duckduckgo-duckduckgo-zero-click-info.p.rapidapi.com/',
  params: {
    q: 'никополь обстрел',
    callback: 'process_duckduckgo',
    no_html: '1',
    no_redirect: '1',
    skip_disambig: '1',
    format: 'json'
  },
  headers: {
    'X-RapidAPI-Key': 'dd5c844ademsh435d59732eed2dep10bff5jsn350385712305',
    'X-RapidAPI-Host': 'duckduckgo-duckduckgo-zero-click-info.p.rapidapi.com'
  }
};

axios.request(options).then(function (response) {
	console.log(response.data);
}).catch(function (error) {
	console.error(error);
});
