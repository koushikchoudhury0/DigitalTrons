const app = require("app")

exports.handler = async(e) => {
    let [reqB, resB, response] = app.parseRequest(e)
    let connection = await app.connect(process.env.DEPLOYMENT)
    let [result, cols] = await connection.execute(`SELECT d FROM file_hierarchy T WHERE T.path = '${reqB.path.replace(/^\/|\/$/g, '')}' AND d=1`)
    
    if (result.length!=1) return app.sabotage(connection, 101, "Invalid Path. Specified Path Must Exists & be a Folder")
    /*Improvement: Break Error Reporting into NOT_EXISTS, NOT_A_FOLDER, NAME_EXISTS*/    
    
    try {
        await connection.execute(`
            INSERT INTO filesystem(node, parent, d) VALUES('${reqB.node}', '${reqB.path.replace(/^\/|\/$/g, '').split("/").pop()}', ${reqB.d})
        `)
    } catch(err) {
        return app.sabotage(connection, 103, err.errno==1062?"File or Folder with Same name already Exists":"Something Went Wrong")
    }
    return app.respond(connection, resB)
}


