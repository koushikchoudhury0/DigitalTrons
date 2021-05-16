const app = require("app")

exports.handler = async(e) => {
    let [reqB, resB, response] = app.parseRequest(e)
    let connection = await app.connect()
    let [notifs, cols] = await connection.execute(`SELECT * FROM add_notification`)    
    return app.respond(connection, {...resB, notifications: notifs})
}


