/*
 Copyright 2010-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License").
 You may not use this file except in compliance with the License.
 A copy of the License is located at

 http://aws.amazon.com/apache2.0

 or in the "license" file accompanying this file. This file is distributed
 on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 express or implied. See the License for the specific language governing
 permissions and limitations under the License.
 */


import Foundation
import AWSCore


@objcMembers
public class CSStockGetResponseMethodModel : AWSModel {
    
    var currentPrice: String?
    var previousClose: String?
    var open: String?
    var daysRange: String?
    var week52Range: String?
    var earningsDate: String?
    var nameOfTheListing: String?
    var updatedDateTime: String?
    
   	public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
		var params:[AnyHashable : Any] = [:]
		params["currentPrice"] = "CurrentPrice"
		params["previousClose"] = "PreviousClose"
		params["open"] = "Open"
		params["daysRange"] = "DaysRange"
		params["week52Range"] = "Week52Range"
		params["earningsDate"] = "EarningsDate"
		params["nameOfTheListing"] = "NameOfTheListing"
		params["updatedDateTime"] = "UpdatedDateTime"
		
        return params
	}
}
