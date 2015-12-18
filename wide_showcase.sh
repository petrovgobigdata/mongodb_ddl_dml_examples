--Create Database
use ws
--To check your currently selected database use the command db
db
--If you want to check your databases list, then use the command show dbs.
show dbs

--Date datatype:
-- Z = +00 - UTC формат
-- +03 - Russia, Moscow
-- DATE
-- min date = 1800-01-01
-- max date = 3000-01-01
-- Широкая витрина. Соцдем
-- Медленно меняющаяся размерность Адрес вынесена в изменение (Array of Embedded Documents)
db.addr.insert({
    _id: ObjectId("567167ec31e8d250423b0dfa"),
    "name": "Yury",
    "sex": "M",
    "birthday": new Date("1985-01-15"),
    "addr": [
        {"location": "Москва", "street": "новая", "date_from": new Date("2015-12-01"), "date_to": new Date("3000-01-01")}
    ]
})

-- Закроем предыдущую версию адреса и добавим новую
db.addr.update(
   { _id: ObjectId("567167ec31e8d250423b0dfa"), addr: { $elemMatch: { date_to: { $eq: ISODate("3000-01-01")} } } },
   {
     $set: { "addr.$.date_to" : new Date("2015-12-05") }
   }
)
db.addr.update(
   { _id: ObjectId("567167ec31e8d250423b0dfa") },
   {
     $push: {
       addr: {"location": "Саратов", "street": "старая", "date_from": new Date("2015-12-05"), "date_to": new Date("3000-01-01")}
     }
   }
)

-- Закроем предыдущую версию адреса и добавим новую
var mynewdate = new Date()
db.addr.update(
   { _id: ObjectId("567167ec31e8d250423b0dfa"), addr: { $elemMatch: { date_to: { $eq: ISODate("3000-01-01")} } } },
   {
     $set: { "addr.$.date_to" : mynewdate }
   }
)
db.addr.update(
   { _id: ObjectId("567167ec31e8d250423b0dfa") },
   {
     $push: {
       addr: {"location": "Владимир", "street": "Лесная", "date_from": mynewdate, "date_to": new Date("3000-01-01")}
     }
   }
)

-- Выведем на экран версию, которая действовала "2015-12-06"
var valid_for = ISODate("2015-12-06")
db.addr.find(
    {_id: ObjectId("567167ec31e8d250423b0dfa")},
    {_id: 0, name: 1, sex: 1, birthday: 1, addr: { $elemMatch: { date_from: { $lte: valid_for}, date_to: { $gt: valid_for} } }}
)

-- Выведем на экран актуальную версию
var valid_for = new Date()
db.addr.find(
    {_id: ObjectId("567167ec31e8d250423b0dfa")},
    {_id: 0, name: 1, sex: 1, birthday: 1, addr: { $elemMatch: { date_from: { $lte: valid_for}, date_to: { $gt: valid_for} } }}
)






--db.order.aggregate({$project:{date:{$dateToString:{format:"%Y-%m-%d",date:"$CreatedDate"}}}})
--{ "_id" : ObjectId("54de670484fec29e87965927"), "date" : "2015-01-18" }

db.addr.find()
db.addr.find({},{_id: 0, name: 1, "addr.date_from": 1})
--$slice = TOP
db.addr.find({},{_id: 0, name: 1, "addr": { $slice: 5 }})
db.addr.aggregate({$project: {_id: 0, name: 1, "addr.date_from": 1}})
db.addr.aggregate({$project: {_id: 0, name: 1, addr: {date_from.$: 1}}})


