SetVar(
	global = 0,
	type_new_page_id = TxId(NewPage),
	type_new_contract_id = TxId(NewContract),
	type_append_id = TxId(AppendPage),
	type_new_column_id = TxId(NewColumn),
	sc_conditions = "$citizen == #wallet_id#",
    sc_value1 = `contract SendMoney {
                 tx {
                         RecipientAccountId int
                         Amount money
                 }

				 func front {
				 	if DBAmount(Table("accounts"),"citizen_id", $citizen ) < $Amount {
					 	error "not enough money"
					}
				 }
               	func main {
				    var sender_id int
                 	sender_id  = DBIntExt( Table("accounts"), "id", $citizen, "citizen_id")
			        DBTransfer(Table("accounts"), "amount,id", sender_id, $RecipientAccountId, $Amount)
                 }
}`,
    sc_value2 = `contract AddAccount {
                 	tx {
                 	    Citizen string
                     }
					func front {
						if AddressToId($Citizen)==0 {
							error "not valid citizen id"
						}
					}
                 	func main {
                        DBInsert(Table( "accounts"), "citizen_id", AddressToId($Citizen))
                 	}
                 }`,
    sc_value3 = `contract UpdAmount {
                 	tx {
                         AccountId int
                         Amount money
                     }

                 	func main {
                         DBUpdate(Table("accounts"), $AccountId, "amount", $Amount)
                 	}
                 }`,
    `page_dashboard_default #= MarkDown : ## My account
Table{
	Table: #state_id#_accounts
		Where: citizen_id='#citizen#'
		Columns: [[amount, #amount#]]
}

MarkDown : ## Accounts
Table{
	Table: #state_id#_accounts
	Order: id
	Columns: [[ID, #id#], [Amount, #amount#], [Send money,BtnTemplate(SendMoney,Send,"RecipientAccountId:#id#")]]
}`,

    `page_government #= TemplateNav(AddAccount, AddAccount) BR()
     TemplateNav(SendMoney, SendMoney) BR()
     TemplateNav(UpdAmount, UpdAmount) BR()

     MarkDown : ## Citizens
     Table{
         Table: #state_id#_citizens
         Order: id
         Columns: [[Avatar,Image(#avatar#)], [ID, Address(#id#)], [Name, #name#]]
     }`,
     page_send_money = `Title : Best country
                        Navigation( LiTemplate(government),non-link text)
                        PageTitle : Dashboard
                        TxForm { Contract: SendMoney }`,
     page_add_account = `Title : Best country
                         Navigation( LiTemplate(government),non-link text)
                         PageTitle : Dashboard
                         TxForm { Contract: AddAccount }`,
     page_upd_amount = `Title : Best country
                        Navigation( LiTemplate(government),non-link text)
                        PageTitle : Dashboard
                        TxForm { Contract: UpdAmount }`
)
TextHidden( sc_value1, sc_value2, sc_value3, sc_conditions )
TextHidden( page_dashboard_default, page_dashboard_goventment, page_send_money, page_add_account, page_upd_amount )

Json(`Head: "Adding account column",
	Desc: "This application adds citizen_id column into account table.",
	OnSuccess: {
		script: 'template',
		page: 'government',
		parameters: {}
	},
	TX: [
		{
		Forsign: 'global,name,value,conditions',
		Data: {
			type: "NewContract",
			typeid: #type_new_contract_id#,
			global: #global#,
			name: "SendMoney",
			value: $("#sc_value1").val(),
			conditions: $("#sc_conditions").val()
			}
	   },
		{
		Forsign: 'global,name,value,conditions',
		Data: {
			type: "NewContract",
			typeid: #type_new_contract_id#,
			global: #global#,
			name: "AddAccount",
			value: $("#sc_value2").val(),
			conditions: $("#sc_conditions").val()
			}
	   },
		{
		Forsign: 'global,name,value,conditions',
		Data: {
			type: "NewContract",
			typeid: #type_new_contract_id#,
			global: #global#,
			name: "UpdAmount",
			value: $("#sc_value3").val(),
			conditions: $("#sc_conditions").val()
			}
	   },
        	   {
        		Forsign: 'table_name,column_name,permissions,index',
        		Data: {
        			type: "NewColumn",
        			typeid: #type_new_column_id#,
        			table_name : "#state_id#_accounts",
        			column_name: "citizen_id",
        			permissions: "$citizen == #wallet_id#",
        			index: 1
        		}
        		},
               {
               		Forsign: 'global,name,value',
               		Data: {
               			type: "AppendPage",
               			typeid: #type_append_id#,
               			name : "dashboard_default",
               			value: $("#page_dashboard_default").val(),
               			global: #global#
               		}
               },
           {
           		Forsign: 'global,name,value',
           		Data: {
           			type: "AppendPage",
           			typeid: #type_append_id#,
           			name : "goventment",
           			value: $("#page_dashboard_goventment").val(),
           			global: #global#
           		}
           },
                   {
                   		Forsign: 'global,name,value,conditions',
                   		Data: {
                   			type: "NewPage",
                   			typeid: #type_new_page_id#,
                   			name : "SendMoney",
                   			value: $("#page_send_money").val(),
                   			global: #global#,
                    		conditions: "$citizen == #wallet_id#",
                   		}
                   },
                           {
                           		Forsign: 'global,name,value,conditions',
                           		Data: {
                           			type: "NewPage",
                           			typeid: #type_new_page_id#,
                           			name : "AddAccount",
                           			value:  $("#page_add_account").val(),
                           			global: #global#,
                            		conditions: "$citizen == #wallet_id#",
                           		}
                           },
                                   {
                                   		Forsign: 'global,name,value,conditions',
                                   		Data: {
                                   			type: "NewPage",
                                   			typeid: #type_new_page_id#,
                                   			name : "UpdAmount",
                                   			value: $("#page_upd_amount").val(),
                                   			global: #global#,
                                    		conditions: "$citizen == #wallet_id#",
                                   		}
                                   }
	]
`)
