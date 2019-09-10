
async function resSuccess(res, message, get) {
    res.send({
        code: 200,
        msg: message,
        data: get,
    });
}

async function resError(res, message, get) {
    res.send({
        code: 500,
        msg: message,
        data: get,
    });
}

module.exports = {
    resSuccess,
    resError,
}
