const axios = require("axios");

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
