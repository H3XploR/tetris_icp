/* 
    guest ne va enregistrer aucune donné sur le canister

*/
persistent actor {
  /*
    Cet actor va gerer les guests (les non enregistrés), et ceux qui s'enregistre, Pour cela il me faudra un boolean, pour savoir
    Si l'user est un guest ou quelqu'un d'enregistré, par default il sera un guest.
  */
  let registered : Bool = false; //donc un guest par default
  public query func greetGuest() : async Text {
      return "Hello, guest, u aren't registered !";
  }

};
