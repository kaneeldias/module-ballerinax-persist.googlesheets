// Copyright (c) 2023 WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/persist;

OrderItem orderItem1 = {
    orderId: "order-1",
    itemId: "item-1",
    quantity: 5,
    notes: "none"
};

OrderItem orderItem2 = {
    orderId: "order-2",
    itemId: "item-2",
    quantity: 10,
    notes: "more"
};

OrderItem orderItem2Updated = {
    orderId: "order-2",
    itemId: "item-2",
    quantity: 20,
    notes: "more than more"
};

@test:Config {
    groups: ["composite-key", "google-sheets"],
    enable: false
}
function gsheetsCompositeKeyCreateTest() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    [string, string][] ids = check rainierClient->/orderitems.post([orderItem1, orderItem2]);
    test:assertEquals(ids, [[orderItem1.orderId, orderItem1.itemId], [orderItem2.orderId, orderItem2.itemId]]);

    OrderItem orderItemRetrieved = check rainierClient->/orderitems/[orderItem1.orderId]/[orderItem1.itemId].get();
    test:assertEquals(orderItemRetrieved, orderItem1);

    orderItemRetrieved = check rainierClient->/orderitems/[orderItem2.orderId]/[orderItem2.itemId].get();
    test:assertEquals(orderItemRetrieved, orderItem2);
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyCreateTest],
    enable: false
}
function gsheetsCmpositeKeyCreateTestNegative() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    [string, string][]|error ids = rainierClient->/orderitems.post([orderItem1]);
    if ids is persist:AlreadyExistsError {
        test:assertEquals(ids.message(), "Duplicate key: [\"order-1\",\"item-1\"]");
    } else {
        test:assertFail("AlreadyExistsError expected");
    }
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyCreateTest],
    enable: false
}
function gsheetsCompositeKeyReadManyTest() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    stream<OrderItem, error?> orderItemStream = rainierClient->/orderitems.get();
    OrderItem[] orderitem = check from OrderItem orderItem in orderItemStream
        select orderItem;

    test:assertEquals(orderitem, [orderItem1, orderItem2]);
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyCreateTest],
    enable: false
}
function gsheetsCompositeKeyReadOneTest() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    OrderItem orderItem = check rainierClient->/orderitems/[orderItem1.orderId]/[orderItem1.itemId].get();
    test:assertEquals(orderItem, orderItem1);
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyCreateTest],
    enable: false
}
function gsheetsCompositeKeyReadOneTest2() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    OrderItem orderItem = check rainierClient->/orderitems/[orderItem1.orderId]/[orderItem1.itemId].get();
    test:assertEquals(orderItem, orderItem1);
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyCreateTest],
    enable: false
}
function gsheetsCompositeKeyReadOneTestNegative1() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    OrderItem|error orderItem = rainierClient->/orderitems/["invalid-order-id"]/[orderItem1.itemId].get();
    if orderItem is persist:NotFoundError {
        test:assertEquals(orderItem.message(), "Invalid key: {\"orderId\":\"invalid-order-id\",\"itemId\":\"item-1\"}");
    } else {
        test:assertFail("Error expected.");
    }
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyCreateTest],
    enable: false
}
function gsheetsCompositeKeyReadOneTestNegative2() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    OrderItem|error orderItem = rainierClient->/orderitems/[orderItem1.orderId]/["invalid-item-id"].get();
    if orderItem is persist:NotFoundError {
        test:assertEquals(orderItem.message(), "Invalid key: {\"orderId\":\"order-1\",\"itemId\":\"invalid-item-id\"}");
    } else {
        test:assertFail("Error expected.");
    }
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyCreateTest, gsheetsCompositeKeyReadOneTest, gsheetsCompositeKeyReadManyTest, gsheetsCompositeKeyReadOneTest2],
    enable: false
}
function gsheetsCompositeKeyUpdateTest() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    OrderItem orderItem = check rainierClient->/orderitems/[orderItem2.orderId]/[orderItem2.itemId].put({
        quantity: orderItem2Updated.quantity,
        notes: orderItem2Updated.notes
    });
    test:assertEquals(orderItem, orderItem2Updated);

    orderItem = check rainierClient->/orderitems/[orderItem2.orderId]/[orderItem2.itemId].get();
    test:assertEquals(orderItem, orderItem2Updated);   
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyCreateTest, gsheetsCompositeKeyReadOneTest, gsheetsCompositeKeyReadManyTest, gsheetsCompositeKeyReadOneTest2],
    enable: false
}
function gsheetsCompositeKeyUpdateTestNegative() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    OrderItem|error orderItem = rainierClient->/orderitems/[orderItem1.orderId]/[orderItem2.itemId].put({
        quantity: 239,
        notes: "updated notes"
    });
    if orderItem is persist:NotFoundError {
        test:assertEquals(orderItem.message(), "Not found: [\"order-1\",\"item-2\"]");
    } else {
        test:assertFail("Error expected.");
    }
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyUpdateTest],
    enable: false
}
function gsheetsCompositeKeyDeleteTest() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    OrderItem orderItem = check rainierClient->/orderitems/[orderItem2.orderId]/[orderItem2.itemId].delete();
    test:assertEquals(orderItem, orderItem2Updated);

    OrderItem|error orderItemRetrieved = rainierClient->/orderitems/[orderItem2.orderId]/[orderItem2.itemId].get();
    test:assertTrue(orderItemRetrieved is persist:NotFoundError);    
}

@test:Config {
    groups: ["composite-key", "google-sheets"],
    dependsOn: [gsheetsCompositeKeyDeleteTest],
    enable: false
}
function gsheetsCompositeKeyDeleteTestNegative() returns error? {
    GoogleSheetsRainierClient rainierClient =  check new ();
    OrderItem|error orderItem = rainierClient->/orderitems/["invalid-order-id"]/[orderItem2.itemId].delete();
    if orderItem is persist:NotFoundError {
        test:assertEquals(orderItem.message(), "Invalid key: {\"orderId\":\"invalid-order-id\",\"itemId\":\"item-2\"}");
    } else {
        test:assertFail("Error expected.");
    }
}
