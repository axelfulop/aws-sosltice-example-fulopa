const AWS = require('aws-sdk')
const DB = new AWS.DynamoDB.DocumentClient({ region: 'us-east-1' });

exports.handler = async (event, callback) => {
    var payload = event.payload;
    var params = {
        TableName: payload.tableName,
        Item: {
            userId: payload.userId,
            userData: payload.userData
        }
    };

    let putItem = new Promise((res, rej) => {
        let response = {};
        DB.put(params, function (err, data) {
            if (err) {
                console.log("Error", err);
                rej(err);
            } else {
                response = {
                    "payload": {
                        "tableName": payload.tableName,
                        "userId": payload.userId
                    }
                }
                console.log("Se inserto correctamente en dynamo");
                let insertados = {
                    "userId": payload.userId,
                    "userData": payload.userData
                }
                console.log("Datos insertados: " + JSON.stringify(insertados));
                res(response);
            }
        });
    });

    const result = await putItem;
    return result
}

// {
//     "payload": {
//       "tableName": "UserProfile",
//       "userId": "1",
//       "userData": {
//         "email": "test@test.com",
//         "alias": "test"
//       }
//     }
//   }