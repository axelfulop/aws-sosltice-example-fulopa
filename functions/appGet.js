const AWS = require('aws-sdk')
const DB = new AWS.DynamoDB.DocumentClient({ region: 'us-east-1' });

exports.handler = async(event, callback) => {
    var payload = event.payload;
    var searchForParams = {
        TableName: payload.tableName,
        Key: {
            userId: payload.userId
        }
    };

    let getItem = new Promise((res, rej) => {
        DB.get(searchForParams, function(err, data) {
            if (err) {
                console.log("Error", err);
                rej(err);
            } else {
                console.log("Success", data);
                res(data.Item);
            }
        });
    });

    const result = await getItem;
    return result
}


//  Payload:
// {
// "payload":
// {
// "tableName": "UserProfile",
// "userId": "1" 
// }
// }