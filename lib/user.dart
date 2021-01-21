class User {
  String name, address, emailid;
  int age, accountno, mobileno, limit;
  double balance;

  User({
    this.name,
    this.address,
    this.age,
    this.accountno,
    this.mobileno,
    this.emailid,
    this.limit = 500,
    this.balance,
  });
}
