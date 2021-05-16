const app = require("app")

exports.handler = async(e) => {
    let [reqB, resB, response] = app.parseRequest(e)
    let connection = await app.connect(process.env.DEPLOYMENT)
    let [hierarchy, cols] = await connection.execute(searchQuery(reqB.node))    
    return app.respond(connection, {...resB, hierarchy: hierarchy})
}

const searchQuery = (node) => {
    if (!node) return `SELECT * FROM file_hierarchy`
    return `
        SELECT 
            node, 
            d, 
            REPLACE(T.path, (SELECT path FROM file_hierarchy WHERE node='${node}'), '${node}') as descendance,
            T.path as path 
        FROM (SELECT * FROM file_hierarchy WHERE path LIKE '%${node}%') T
    `
}


