const axios = require("axios");

main();

async function main() {
    const options = {
        method: 'POST',
        url: 'https://api.particle.io/v1/devices/37002f000847373336373936/OpenDoor/',
        params: {
            arg: 10,
        },
        headers: {
          'Authorization': 'Bearer 0530c43d361545a127a2dcd3292f840036353a52',
          'Content-Type': 'application/x-www-form-urlencoded'
        }
    };

    let dt1 = 1 * (new Date());
    let result = await axios.request(options);
    let dt2 = 1 * (new Date());
    let delta = (dt2 - dt1) / 1000;
    console.log('got res', result.data, 'for', delta);
}