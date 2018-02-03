pragma solidity ^0.4.4;

/**
 * A Contract can create other contracts.
 * Represents an asset such as car, diamond, land-deed ....
 **/

contract  ChildContract {
  // Represents the identifier for some kind of asset

  uint8     public  identity;
  address   public  owner;
  bytes32   public  name;
  bytes32   public  propertyName;
  uint8     public  unitNo;
  uint8     public  price;
  uint8     public  numRoom;
  uint8     public  bathroom;
  uint8     public  size;
  bytes32   public  propertyType;
  bytes32   public  propertyDecription;
  address[] public  prevOwner;
 
  modifier  OwnerOnly {if(msg.sender != owner) /**throw**/ revert(); else _;}
  event     ChildOwnerTransfered(uint8 identity, bytes32 from, bytes32 to);

  // Constructor  
  function  ChildContract(bytes32 _propertyName, uint8 _unitNo ,  uint8 _price, uint8  _numRoom ,uint8  _bathroom  ,uint8  _size, bytes32  _propertyType,bytes32  _propertyDecription ) public {
        propertyName=_propertyName;
        unitNo= _unitNo;
        price= _price;
        numRoom=_numRoom;
        bathroom= _bathroom;
        size= _size;
        propertyType= _propertyType;
        propertyDecription= _propertyDecription;
  }

  // transfer the ownership
  function  transferOwnership (address newOwner, bytes32 nm) OwnerOnly {
    bytes32  former = name; 
    prevOwner.push(owner);
    owner = newOwner;
    name = nm;
    ChildOwnerTransfered(identity, former, name);
  }
  // checks if caller is the owner
  function  isOwner(address addr) returns(bool) {
    return (addr == owner);
  }
}


/**
 * This contract creates multiple child contracts.
 **/
contract ContractFactory {
  // Maintains all the child contracts
  ChildContract[] children;
  // Price of the asset
  uint8    public   initialPrice;
  address[] public  prevOwner;
  uint8 public number ;

    // Constructor
    // Creates the child contracts
    // add new child contract in to network 
    function ContractFactory()
    {
       
    }
    function AddChildContract(bytes32 _propertyName, uint8 _unitNo ,  uint8 _price, uint8  _numRoom ,uint8  _bathroom  ,uint8  _size, bytes32  _propertyType,bytes32  _propertyDecription){

        children.push(new ChildContract( _propertyName, _unitNo ,  _price,  _numRoom ,_bathroom  ,_size,  _propertyType, _propertyDecription));
        prevOwner.push(msg.sender);
        
    }
  // Anyone can pay the price and purchase the asset

  function  purchase(bytes32 name, bytes32 _uintNo) payable {

    if(msg.value < initialPrice) /*throw*/ revert();
    // Look for available asset i.e., one that is not sold yet
    for(uint8 i = 0; i < children.length; i++){
      // Check if contract factoy is the owner
      if(children[i].isOwner(this)){
        children[i].transferOwnership(msg.sender, name);
        return;
      }
    }
    // No more assets available - so throw an exception
    /**throw**/ revert();
  }

//function convert byte to string 
    function bytes32ToString(bytes32 x) constant returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
  // Returns the information about the child contract at specified index
  function getPropertyName(uint8 childIndex) constant returns (string){
        return bytes32ToString(children[childIndex].propertyName());
         
    }
        function getUnitNo(uint8 childIndex) constant returns (uint8){
        return children[childIndex].unitNo();
    }
        function getPrice(uint8 childIndex) constant returns (uint8){
        return children[childIndex].price();
    }
        function getNumRoom(uint8 childIndex) constant returns (uint8){
        return children[childIndex].numRoom();
    }
        function getNumBathroom(uint8 childIndex) constant returns (uint8){
        return children[childIndex].bathroom();
    }
        function getSize(uint8 childIndex) constant returns (uint8){
        return children[childIndex].size();
    }
        function getPropertyType(uint8 childIndex) constant returns (string){
        return bytes32ToString(children[childIndex].propertyType());
    }
        function getPropertyDecription(uint8 childIndex) constant returns (string){
        return bytes32ToString(children[childIndex].propertyDecription());
    }
    function adddata(uint8 n){
        number=n;
    }
    
  //Returns the child contract address
  function  getChildContractAddress(uint8 childIndex) returns (address){
    return address(children[childIndex]);
  }

  // Returns name of the owner based on the child index
  function  getOwnerName(uint8 childIndex) constant returns(bytes32){
    bytes32  namer = children[childIndex].name();
    return namer;
  }

  
}