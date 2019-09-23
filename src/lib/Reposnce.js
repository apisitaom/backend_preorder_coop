
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
async function resSuccuessToken(res, message, datas, tokens) {
    res.send({
        code: 200,
        msg: message,
        data: datas,
        token: tokens,
    });
}

module.exports = {
    resSuccess,
    resError,
    resSuccuessToken
}
