const axios = require("axios");

const options = {
  method: 'GET',
  url: encodeURI('https://google-search3.p.rapidapi.com/api/v1/search/q=никополь+обстрел'),
  headers: {
    'X-User-Agent': 'desktop',
    'X-Proxy-Location': 'EU',
    'X-RapidAPI-Key': 'dd5c844ademsh435d59732eed2dep10bff5jsn350385712305',
    'X-RapidAPI-Host': 'google-search3.p.rapidapi.com'
  }
};

axios.request(options).then(function (response) {
	console.log(response.data);
}).catch(function (error) {
	console.error(error);
});
