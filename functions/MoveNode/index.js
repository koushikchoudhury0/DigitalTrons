const app = require("app")

exports.handler = async(e) => {    
    let [reqB, resB, response] = app.parseRequest(e)
    let connection = await app.connect()
    try {
        let updation = await connection.execute(`UPDATE filesystem SET parent='${reqB.target}' WHERE node='${reqB.node}'`)
        console.log("UPDATED: ", updation[0].affectedRows)
        if (updation[0].affectedRows!=1) {
            return app.sabotage(connection, 102, "Non Existant or Same Target Folder Specified")    
        }
    } catch(err) {
        return app.sabotage(connection, 101, err.sqlState==45001?err.sqlMessage:"Something Went Wrong")
    }
    return app.respond(connection, resB)
}


