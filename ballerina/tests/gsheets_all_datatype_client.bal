// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/jballerina.java;
import ballerinax/googleapis.sheets;
import ballerina/http;
import ballerina/persist;

const ORDER_ITEM_EXTENDED = "orderitemextendeds";

public isolated client class GoogleSheetsRainierClientAllDataType {
    *persist:AbstractPersistClient;

    private final sheets:Client googleSheetClient;

    private final http:Client httpClient;

    private final map<GoogleSheetsClient> persistClients;

    public isolated function init() returns persist:Error? {
        final record {|SheetMetadata...;|} & readonly metadata = {
            [ORDER_ITEM_EXTENDED] : {
                entityName: "OrderItemExtended",
                tableName: "OrderItemExtended",
                keyFields: ["orderId", "itemId"],
                range: "A:K",
                query: self.queryOrderitemextendeds,
                queryOne: self.queryOneOrderitemextendeds,
                dataTypes: {
                    orderId: "string",
                    itemId: "string",
                    CustomerId: "int",
                    paid: "boolean",
                    ammountPaid: "float",
                    ammountPaidDecimal: "decimal",
                    arivalTimeCivil: "time:Civil",
                    arivalTimeUtc: "time:Utc",
                    arivalTimeDate: "time:Date",
                    arivalTimeTimeOfDay: "time:TimeOfDay",
                    orderType: "ENUM"
                },
                fieldMetadata: {
                    orderId: {columnName: "orderId", columnId: "A"},
                    itemId: {columnName: "itemId", columnId: "B"},
                    CustomerId: {columnName: "CustomerId", columnId: "C"},
                    paid: {columnName: "paid", columnId: "D"},
                    ammountPaid: {columnName: "ammountPaid", columnId: "E"},
                    ammountPaidDecimal: {columnName: "ammountPaidDecimal", columnId: "F"},
                    arivalTimeCivil: {columnName: "arivalTimeCivil", columnId: "G"},
                    arivalTimeUtc: {columnName: "arivalTimeUtc", columnId: "H"},
                    arivalTimeDate: {columnName: "arivalTimeDate", columnId: "I"},
                    arivalTimeTimeOfDay: {columnName: "arivalTimeTimeOfDay", columnId: "J"},
                    orderType: {columnName: "orderType", columnId: "K"}
                },
                associationsMethods: {}
            }
        };
        sheets:ConnectionConfig sheetsClientConfig = {
            auth: {
                clientId: clientId,
                clientSecret: clientSecret,
                refreshUrl: sheets:REFRESH_URL,
                refreshToken: refreshToken
            }
        };
        http:ClientConfiguration httpClientConfiguration = {
            auth: {
                clientId: clientId,
                clientSecret: clientSecret,
                refreshUrl: sheets:REFRESH_URL,
                refreshToken: refreshToken
            }
        };
        http:Client|error httpClient = new ("https://docs.google.com/spreadsheets", httpClientConfiguration);
        if httpClient is error {
            return <persist:Error>error(httpClient.message());
        }
        sheets:Client|error googleSheetClient = new (sheetsClientConfig);
        if googleSheetClient is error {
            return <persist:Error>error(googleSheetClient.message());
        }
        self.googleSheetClient = googleSheetClient;
        self.httpClient = httpClient;
        map<int> sheetIds = check getSheetIds(self.googleSheetClient, metadata, spreadsheetId);
        self.persistClients = {[ORDER_ITEM_EXTENDED] : check new (self.googleSheetClient, self.httpClient, metadata.get(ORDER_ITEM_EXTENDED).cloneReadOnly(), spreadsheetId.cloneReadOnly(), sheetIds.get(ORDER_ITEM_EXTENDED).cloneReadOnly())};
    }

    isolated resource function get orderitemextendeds(OrderItemExtendedTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.googlesheets.datastore.GoogleSheetsProcessor",
        name: "query"
    } external;

    isolated resource function get orderitemextendeds/[string orderId]/[string itemId](OrderItemExtendedTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.googlesheets.datastore.GoogleSheetsProcessor",
        name: "queryOne"
    } external;

    isolated resource function post orderitemextendeds(OrderItemExtendedInsert[] data) returns [string, string][]|persist:Error {
        GoogleSheetsClient googleSheetsClient;
        lock {
            googleSheetsClient = self.persistClients.get(ORDER_ITEM_EXTENDED);
        }
        _ = check googleSheetsClient.runBatchInsertQuery(data);
        return from OrderItemExtendedInsert inserted in data
            select [inserted.orderId, inserted.itemId];
    }

    isolated resource function put orderitemextendeds/[string orderId]/[string itemId](OrderItemExtendedUpdate value) returns OrderItemExtended|persist:Error {
        GoogleSheetsClient googleSheetsClient;
        lock {
            googleSheetsClient = self.persistClients.get(ORDER_ITEM_EXTENDED);
        }
        _ = check googleSheetsClient.runUpdateQuery({"orderId": orderId, "itemId": itemId}, value);
        return self->/orderitemextendeds/[orderId]/[itemId].get();
    }

    isolated resource function delete orderitemextendeds/[string orderId]/[string itemId]() returns OrderItemExtended|persist:Error {
        OrderItemExtended result = check self->/orderitemextendeds/[orderId]/[itemId].get();
        GoogleSheetsClient googleSheetsClient;
        lock {
            googleSheetsClient = self.persistClients.get(ORDER_ITEM_EXTENDED);
        }
        _ = check googleSheetsClient.runDeleteQuery({"orderId": orderId, "itemId": itemId});
        return result;
    }

    private isolated function queryOrderitemextendeds(string[] fields) returns stream<record {}, persist:Error?>|persist:Error {
        stream<OrderItemExtended, persist:Error?> orderitemextendedsStream = self.queryOrderitemextendedsStream();
        record {}[] outputArray = check from record {} 'object in orderitemextendedsStream
            select persist:filterRecord({
                ...'object
            }, fields);
        return outputArray.toStream();
    }

    private isolated function queryOneOrderitemextendeds(anydata key) returns record {}|persist:NotFoundError {
        stream<OrderItemExtended, persist:Error?> orderitemextendedsStream = self.queryOrderitemextendedsStream();
        error? unionResult = from record {} 'object in orderitemextendedsStream
            where persist:getKey('object, ["orderId", "itemId"]) == key
            do {
                return {
                    ...'object
                };
            };
        if unionResult is error {
            return <persist:NotFoundError>error(unionResult.message());
        }
        return <persist:NotFoundError>error("Invalid key: " + key.toString());
    }

    private isolated function queryOrderitemextendedsStream(OrderItemExtendedTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.googlesheets.datastore.GoogleSheetsProcessor",
        name: "queryStream"
    } external;

    public isolated function close() returns persist:Error? {
        return ();
    }
}
