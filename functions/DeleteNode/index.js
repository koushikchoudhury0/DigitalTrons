const app = require("app")

exports.handler = async(e) => {
    let [reqB, resB, response] = app.parseRequest(e)
    let connection = await app.connect(process.env.DEPLOYMENT)
    await connection.execute(deleteQuery(reqB.node))    
    return app.respond(connection, resB)
}

const deleteQuery = (node) => {
    if (!node) throw Error("No File or Folder Specified")
    return `
        DELETE FROM filesystem WHERE node IN (
            SELECT 
                node
            FROM (SELECT * FROM file_hierarchy WHERE path LIKE '%${node}%') T
        )
    `
}


