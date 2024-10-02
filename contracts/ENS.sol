// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//@todo - add custom error

contract Ens {
    address owner;
    uint registrationPrice;
    uint renewalCoefficient;

    struct Registration {
        address owner;
        uint timestamp;
        uint initialValue;
        uint totalValue;
        uint registrationYears;
        uint timestampLastRenewal;
    } 

    mapping(string => Registration) enss;
    
    modifier onlyOwner {
        require(owner == msg.sender, "Only owner is acceptable");
        _;
    }

    modifier onlyDomainOwner(string memory _name) {
        require(enss[_name].owner == msg.sender, "Only domain owner is acceptable.");
        _;
    }

    modifier checkAmountOfRegistrationYears(uint _years) {
        require(_years >= 1 && _years <= 10, "Registration years amount acceptable from 1 up to 10 years.");
        _;
    }

    modifier checkDomainRegistrationIsExistOrExpired(string memory _name) {
        uint oneyear = 31556926;
        require(enss[_name].timestamp + enss[_name].registrationYears * oneyear < block.timestamp, "Domain is registered and active.");
        _;
    }

    modifier checkValueForRenewal(string memory _name, uint _years) {
        require(enss[_name].initialValue * renewalCoefficient * _years <= msg.value, "Incufficient value for domain renewal.");
        _;
    }

    modifier checkValueForPriceRegistration(uint _years) {
        require(registrationPrice*_years <= msg.value, "Incufficient value for domain registration.");
        _;
    }

    modifier checkDomainIsRegistered(string memory _name) {
        require(enss[_name].timestamp > 0, "Domain is not registered yet.");
        _;
    }

    event DomainNameIsRegistered(address indexed  _addr, string indexed _name, uint timestamp, uint _years);

    event DomainNameIsRenewed(address indexed  _addr, string indexed _name, uint timestamp, uint _years);

    constructor(uint _price, uint _coefficient) {
        owner = msg.sender;
        registrationPrice = _price;
        renewalCoefficient = _coefficient;
    }

    function getRegistrationPrice() public view returns(uint){
        return registrationPrice;
    }

        function getRenewCoefficient() public view returns(uint){
        return renewalCoefficient;
    }

    function setPriceRegistrationPerYear(uint _price) public onlyOwner {
        registrationPrice = _price;
    }

    function setRenewalCoefficient(uint _coefficient) public onlyOwner {
        renewalCoefficient = _coefficient;
    }

    function getAddress(string memory _ensDomain) public view returns (address) {
        return enss[_ensDomain].owner;
    }

    function withdraw(address _to) public onlyOwner{
        payable(_to).transfer(address(this).balance);
    }

    function registerDomainName(string memory _name, uint _years) public checkDomainRegistrationIsExistOrExpired(_name) checkAmountOfRegistrationYears(_years) checkValueForPriceRegistration(_years) payable {
        
        enss[_name] = Registration({ owner: msg.sender, timestamp: block.timestamp, initialValue: msg.value, totalValue: msg.value, registrationYears: _years, timestampLastRenewal: 0});
        emit DomainNameIsRegistered(msg.sender, _name, block.timestamp, _years);
    }

    function renewalDomainNameRegistration(string memory _name, uint _years) public checkDomainIsRegistered(_name) onlyDomainOwner(_name) checkAmountOfRegistrationYears(_years) checkValueForRenewal(_name, _years)  payable {
        enss[_name] = Registration({owner: msg.sender, timestamp: block.timestamp, initialValue: enss[_name].initialValue, totalValue: enss[_name].totalValue + msg.value, registrationYears: enss[_name].registrationYears + _years, timestampLastRenewal: block.timestamp});
        emit DomainNameIsRenewed(msg.sender, _name, block.timestamp, _years);
    }

    function getDomainInfo(string memory _name) public view returns(Registration memory) {
        return enss[_name];
    }
}