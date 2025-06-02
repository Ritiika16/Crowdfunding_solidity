let web3;
let contract;
const contractAddress = "0xFd33eca8D6411f405637877c9C7002D321182937";
import abi from './crowdfunding_abi.json'; // Copy from Remix Compilation Details

async function connectWallet() {
    if (window.ethereum) {
        web3 = new Web3(window.ethereum);
        await window.ethereum.enable();
        contract = new web3.eth.Contract(abi, contractAddress);
        alert("Wallet connected!");
    } else {
        alert("Please install MetaMask.");
    }
}

async function createCampaign() {
    const accounts = await web3.eth.getAccounts();
    const title = document.getElementById("title").value;
    const description = document.getElementById("description").value;
    const goal = document.getElementById("goal").value;
    const duration = document.getElementById("duration").value;
    await contract.methods.createCampaign(title, description, goal, duration).send({from: accounts[0]});
    alert("Campaign created!");
}

async function pledge() {
    const accounts = await web3.eth.getAccounts();
    const campaignId = document.getElementById("campaignIdPledge").value;
    const amount = document.getElementById("amountPledge").value;
    await contract.methods.pledge(campaignId).send({from: accounts[0], value: amount});
    alert("Pledge successful!");
}

async function claimFunds() {
    const accounts = await web3.eth.getAccounts();
    const campaignId = document.getElementById("campaignIdClaim").value;
    await contract.methods.claimFunds(campaignId).send({from: accounts[0]});
    alert("Funds claimed!");
}
