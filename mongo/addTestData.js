use hms;
var bulk = db.testColl.initializeUnorderedBulkOp();
people = ["Marc", "Bill", "George", "Eliot", "Matt", "Trey", "Tracy", "Greg", "Steve", "Kristina", "Katie", "Jeff"];
for(var i = 0; i< 1000000; i++){
   user_id = i;
   name = people[Math.floor(Math.random() * people.length)];
   bulk.insert( { "_id": user_id, "name": name});
}
bulk.execute();

var bulk = db.testColl.initializeUnorderedBulkOp();
people = ["Marc", "Bill", "George", "Eliot", "Matt", "Trey", "Tracy", "Greg", "Steve", "Kristina", "Katie", "Jeff"];
for(var i = 1000000; i< 2000000; i++){
   user_id = i;
   name = people[Math.floor(Math.random() * people.length)];
   bulk.insert( { "_id": user_id, "name": name});
}
bulk.execute();

var bulk = db.testColl.initializeUnorderedBulkOp();
people = ["Marc", "Bill", "George", "Eliot", "Matt", "Trey", "Tracy", "Greg", "Steve", "Kristina", "Katie", "Jeff"];
for(var i=0; i<1000000; i++){
   user_id = i;
   name = people[Math.floor(Math.random()*people.length)];
   bulk.insert( { _id: user_id, "user_id":user_id, "name":name});
}
bulk.execute();
