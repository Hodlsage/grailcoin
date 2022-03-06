
// ----------------------------------------------------------------------------
// --- GrailCoinTreasury - Vault Contract
// --- Symbol      : GCT
// --- Name        : GrailCoin
// --- Total supply: Generated from Vault minter accounts
// --- @author EJS32 
// --- @title for 01101101 01111001 01101100 01101111 01110110 01100101
// --- @dev pragma solidity version:0.8.8+commit.dddeac2f
// --- (c) ArtGrails.com - 2019. The MIT License.
// --- SPDX-License-Identifier: MIT
// ----------------------------------------------------------------------------

pragma solidity 0.8.8;

// ----------------------------------------------------------------------------
// --- Address Library
// ----------------------------------------------------------------------------

library Address {

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// ----------------------------------------------------------------------------
// --- Safe Library
// ----------------------------------------------------------------------------

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// ----------------------------------------------------------------------------
// --- Contract Context 
// ----------------------------------------------------------------------------

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// ----------------------------------------------------------------------------
// --- Contract ERC20 
// ----------------------------------------------------------------------------

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
      uint8 private _decimals;
    
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }
    
    function totalSupply() public override view virtual returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public override view virtual returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override virtual returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public override view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override virtual returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override virtual returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
    
        function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }
}

// ----------------------------------------------------------------------------
// --- Contract Ownable 
// ----------------------------------------------------------------------------

abstract contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor ()  {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// ----------------------------------------------------------------------------
// --- Contract Blacklistable
// ----------------------------------------------------------------------------

contract Blacklistable is Ownable {

    address public blacklister;
    mapping(address => bool) internal blacklisted;
    event Blacklisted(address indexed _account);
    event UnBlacklisted(address indexed _account);
    event BlacklisterChanged(address indexed newBlacklister);

    modifier onlyBlacklister() {
        require(msg.sender == blacklister);
        _;
    }

    modifier notBlacklisted(address _account) {
        require(blacklisted[_account] == false);
        _;
    }

    function isBlacklisted(address _account) public view returns (bool) {
        return blacklisted[_account];
    }

    function blacklist(address _account) public onlyBlacklister {
        blacklisted[_account] = true;
        emit Blacklisted(_account);
    }

    function unBlacklist(address _account) public onlyBlacklister {
        blacklisted[_account] = false;
        emit UnBlacklisted(_account);
    }

    function updateBlacklister(address _newBlacklister) public onlyOwner {
        require(_newBlacklister != address(0));
        blacklister = _newBlacklister;
        emit BlacklisterChanged(blacklister);
    }
}

// ----------------------------------------------------------------------------
// --- library Roles
// ----------------------------------------------------------------------------

library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// ----------------------------------------------------------------------------
// --- Contract PauserRole
// ----------------------------------------------------------------------------

abstract contract PauserRole is Context {
    using Roles for Roles.Role;
    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);
    Roles.Role private _pausers;
    constructor ()  {
        _addPauser(_msgSender());
    }

    modifier onlyPauser() {
        require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
        _;
    }

    function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }

    function addPauser(address account) public onlyPauser {
        _addPauser(account);
    }

    function renouncePauser() public {
        _removePauser(_msgSender());
    }

    function _addPauser(address account) internal {
        _pausers.add(account);
        emit PauserAdded(account);
    }

    function _removePauser(address account) internal {
        _pausers.remove(account);
        emit PauserRemoved(account);
    }
}

// ----------------------------------------------------------------------------
// --- Contract Pausable
// ----------------------------------------------------------------------------

abstract contract Pausable is Context, PauserRole {

    event Paused(address account);
    event Unpaused(address account);
    bool private _paused;

    constructor ()  {
        _paused = false;
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// ----------------------------------------------------------------------------
// --- Contract GrailCoin
// ----------------------------------------------------------------------------

contract GrailCoin is Ownable, ERC20, Pausable, Blacklistable {
    using SafeMath for uint256;
    string public name;
    string public symbol;
    uint8 public _decimals;
    string public currency;
    address public masterMinter;
    address public pauser;
    bool internal initialized;
    mapping(address => uint256) internal balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    uint256 internal totalSupply_ = 0;
    mapping(address => bool) internal minters;
    mapping(address => uint256) internal minterAllowed;
    event Mint(address indexed minter, address indexed to, uint256 amount);
    event Burn(address indexed burner, uint256 amount);
    event MinterConfigured(address indexed minter, uint256 minterAllowedAmount);
    event MinterRemoved(address indexed oldMinter);
    event MasterMinterChanged(address indexed newMasterMinter);
    
    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _currency,
        address _masterMinter,
        address _pauser,
        address _blacklister,
        address _owner
    ) public {
        require(!initialized);
        require(_masterMinter != address(0));
        require(_pauser != address(0));
        require(_blacklister != address(0));
        require(_owner != address(0));
        name = _name;
        symbol = _symbol;
        currency = _currency;
        masterMinter = _masterMinter;
        pauser = _pauser;
        blacklister = _blacklister;
        initialized = true;
    }

    modifier onlyMinters() {
        require(minters[msg.sender] == true);
        _;
    }

    function mint(address _to, uint256 _amount) whenNotPaused onlyMinters notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool) {
        require(_to != address(0));
        require(_amount > 0);
        uint256 mintingAllowedAmount = minterAllowed[msg.sender];
        require(_amount <= mintingAllowedAmount);
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        minterAllowed[msg.sender] = mintingAllowedAmount.sub(_amount);
        emit Mint(msg.sender, _to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    modifier onlyMasterMinter() {
        require(msg.sender == masterMinter);
        _;
    }

    function minterAllowance(address minter) public view returns (uint256) {
        return minterAllowed[minter];
    }

    function isMinter(address account) public view returns (bool) {
        return minters[account];
    }

    function allowance(address owner, address spender) public override view returns (uint256) {
        return allowed[owner][spender];
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address account) public override view returns (uint256) {
        return balances[account];
    }

    function approve(address _spender, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public override returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) whenNotPaused notBlacklisted(_to) notBlacklisted(msg.sender) notBlacklisted(_from) public override returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) public override returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function configureMinter(address minter, uint256 minterAllowedAmount) whenNotPaused onlyMasterMinter public returns (bool) {
        minters[minter] = true;
        minterAllowed[minter] = minterAllowedAmount;
        emit MinterConfigured(minter, minterAllowedAmount);
        return true;
    }

    function removeMinter(address minter) onlyMasterMinter public returns (bool) {
        minters[minter] = false;
        minterAllowed[minter] = 0;
        emit MinterRemoved(minter);
        return true;
    }

    function burn(uint256 _amount) whenNotPaused onlyMinters notBlacklisted(msg.sender) public {
        uint256 balance = balances[msg.sender];
        require(_amount > 0);
        require(balance >= _amount);
        totalSupply_ = totalSupply_.sub(_amount);
        balances[msg.sender] = balance.sub(_amount);
        emit Burn(msg.sender, _amount);
        emit Transfer(msg.sender, address(0), _amount);
    }

    function updateMasterMinter(address _newMasterMinter) onlyOwner public {
        require(_newMasterMinter != address(0));
        masterMinter = _newMasterMinter;
        emit MasterMinterChanged(masterMinter);
    }
}

// ----------------------------------------------------------------------------
// --- GrailCoin Controller
// ----------------------------------------------------------------------------

interface IGrailCoinCtrl {

    function devfund() external view returns (address);

    function treasury() external view returns (address);

    function earnEnabled() external view returns (bool);

    function whiteList(address) external returns(bool);
    
    function vaults(address) external view returns(address);

    function stakingShareFee() external view returns (uint256);

    function stakingSharePool() external view returns (address);

    function protectionFee() external view returns (uint256);

    function protectionTime() external view returns (uint256);

    function denominatorMax() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function earn(address, uint256) external;

    function withdraw(address, uint256) external;

    function notifyStakingShare(uint256) external;
}

// ----------------------------------------------------------------------------
// --- Contract StakingReward 
// ----------------------------------------------------------------------------

abstract contract StakingReward is ERC20 {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    IERC20 public rewardToken;
    IERC20 public stakingToken;
    
    address public timelock;
    address public controller;
    address public governance;

    uint256 public availableMin = 9500;
    uint256 public constant max = 10000;

    uint256 public earnLowerlimit = 5 ether;

    uint256 public withdrawMaxLimit = 0;
    mapping(address => uint256) public lastDepositTime;

    bool public acceptContractEnable = false;

    uint256 public periodFinish = 0;
    uint256 public rewardRate = 0;
    uint256 public rewardsDuration = 7 days;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public rewards;
    mapping(address => uint256) public userRewardPerTokenPaid;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    constructor(
        address _timelock, 
        address _controller, 
        address _governance,
        address _rewardToken,
        address _stakingToken
    )  ERC20 () {
        require(_timelock != address(0));
        require(_controller != address(0));
        require(_governance != address(0));

        rewardToken = IERC20(_rewardToken);
        stakingToken = IERC20(_stakingToken);
        _setupDecimals(ERC20(_stakingToken).decimals());

        timelock = _timelock;
        controller = _controller;
        governance = _governance;
    }

    modifier checkContract {
        if (!acceptContractEnable && !IGrailCoinCtrl(controller).whiteList(msg.sender)) {
            require(!address(msg.sender).isContract() && msg.sender == tx.origin, "!We don't support contracts");
        }
        _;
    }

// ----------------------------------------------------------------------------
// --- Timelock Function 
// ----------------------------------------------------------------------------

    function setTimelock(address _timelock) public {
        require(msg.sender == timelock, "!timelock");
        timelock = _timelock;
    }

    function setController(address _controller) external {
        require(msg.sender == timelock, "!timelock");
        controller = _controller;
    }

    function setGovernance(address _governance) public {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function setAvailableMin(uint256 _availableMin) external{
        require(msg.sender == governance, "!governance");
        require(_availableMin <= max, "!> denominator");
        availableMin = _availableMin;
    }

    function setWithdrawMaxLimit(uint256 _withdrawMaxLimit) external {
        require(msg.sender == governance, "!governance");
        require(_withdrawMaxLimit > 0, "!withdrawMaxLimit < 0");
        withdrawMaxLimit = _withdrawMaxLimit;
    }

    function setEarnLowerlimit(uint _earnLowerlimit) external {
        require(msg.sender == governance, "!governance");
        earnLowerlimit = _earnLowerlimit;
    }

    function setRewardsDuration(uint256 _rewardsDuration) external {
        require(block.timestamp > periodFinish, "!periodFinish");
        require((msg.sender == controller || msg.sender == governance), "!controller or !strategist");
        rewardsDuration = _rewardsDuration;
    }

    function setAcceptContractEnable(bool _acceptContractEnable) external {
        require(msg.sender == governance, "!governance");
        acceptContractEnable = _acceptContractEnable;
    }

// ----------------------------------------------------------------------------
// --- Reward Function 
// ----------------------------------------------------------------------------

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            rewards[account] = pendingReward(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    function getReward() public updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            uint256 _tokenBal = rewardToken.balanceOf(address(this));
            rewardToken.safeTransfer(msg.sender, (_tokenBal < reward) ? _tokenBal : reward);
            // rewardTotalTokenDistributed = rewardTotalTokenDistributed.sub(reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function rewardPerToken() public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored.add(
                lastTimeRewardApplicable()
                    .sub(lastUpdateTime)
                    .mul(rewardRate)
                    .mul(1e18)
                    .div(_totalSupply)
            );
    }

    function getRewardForDuration() external view returns (uint256) {
        return rewardRate.mul(rewardsDuration);
    }

    function min(uint256 a, uint256 b) public pure returns (uint256) {
        return a < b ? a : b;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return min(block.timestamp, periodFinish);
    }

    function pendingReward(address account) public view returns (uint256) {
        return _balances[account]
                .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
                .div(1e18)
                .add(rewards[account]);
    }

// ----------------------------------------------------------------------------
// --- RewardExtras
// ----------------------------------------------------------------------------

    function notifyRewardAmount(uint256 reward) external updateReward(address(0)) {
        require((msg.sender == controller || msg.sender == governance), "!controller or !strategist");
        if (block.timestamp >= periodFinish) {
            rewardRate = reward.div(rewardsDuration);
        } else {
            uint256 remaining = periodFinish.sub(block.timestamp);
            uint256 leftover = remaining.mul(rewardRate);
            rewardRate = reward.add(leftover).div(rewardsDuration);
        }

        uint256 _rBal = rewardToken.balanceOf(address(this));
        require(rewardRate <= _rBal.div(rewardsDuration), "!reward too high");
        lastUpdateTime = block.timestamp;
        periodFinish = block.timestamp.add(rewardsDuration);
        emit NotifyReward(reward);
    }

// ----------------------------------------------------------------------------
// --- GrailVault - 0: Eth, 1: USDC, 2: USDT, 3: GrailCoin
// ----------------------------------------------------------------------------

    function balance() public view returns (uint256) {
        return stakingToken.balanceOf(address(this)).add(
            IGrailCoinCtrl(controller).balanceOf(address(stakingToken))
        );
    }

    function balanceOfToken() public view returns (uint256) {
        if (balance() == 0 || totalSupply() == 0) {
            return 0;
        } else {
            return balance().mul(balanceOf(msg.sender)).div(totalSupply());
        }
    }

    function available() public view returns (uint256) {
        return stakingToken.balanceOf(address(this)).mul(availableMin).div(max);
    }

    function earn() public {
        if (controller != address(0)) {
            IGrailCoinCtrl _ctrl = IGrailCoinCtrl(controller);
            if (_ctrl.earnEnabled()) {
                uint256 _bal = available();
                stakingToken.safeTransfer(controller, _bal);
                _ctrl.earn(address(stakingToken), _bal);
            }
        }
    }

    function deposit(uint256 _amount) external checkContract {
        require(_amount >= 0, "!_amount > 0");
        uint256 _pool = balance();
        uint256 _before = stakingToken.balanceOf(address(this));
        stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
        uint256 _after = stakingToken.balanceOf(address(this));
        uint256 _totalAmount = _after.sub(_before);
        if (_totalAmount > 0) {
            uint256 _shares = _deposit(address(this), _pool, _totalAmount);
            _stake(_shares);
            lastDepositTime[msg.sender] = block.timestamp;
        }
    }

    function withdraw(uint256 _shares) public {
        uint256 _userBal = balanceOf(msg.sender);
        if (_shares > _userBal) {
            uint256 _need = _shares.sub(_userBal);
            require(_need <= _balances[msg.sender], "_userBal+staked < _shares");
            unstake(_need);
        }

        uint256 r = (balance().mul(_shares)).div(totalSupply());
        _burn(msg.sender, _shares);
        uint256 b = stakingToken.balanceOf(address(this));
        if (b < r) {
            uint256 _amount = r.sub(b);
            IGrailCoinCtrl(controller).withdraw(address(stakingToken), _amount);
            uint256 _after = stakingToken.balanceOf(address(this));
            uint256 _diff = _after.sub(b);
            if (_diff < _amount) {
                r = b.add(_diff);
            }
        }

        stakingToken.safeTransfer(msg.sender, r);
    }

    function _deposit(address _mintTo, uint256 _pool, uint256 _amount) internal returns (uint256 _shares) {
        if (totalSupply() == 0) {
            _shares = _amount;
        } else {
            _shares = (_amount.mul(totalSupply())).div(_pool);
        }
        if (_shares > 0) {
            if (stakingToken.balanceOf(address(this)) > earnLowerlimit) {
                earn();
            }
            _mint(_mintTo, _shares);
        }
    }

// ----------------------------------------------------------------------------
// --- GrailFarm 
// ----------------------------------------------------------------------------

    function _stake(uint256 _shares) internal {
        require(_shares > 0, "!_shares <= 0");
        getReward();
        _totalSupply = _totalSupply.add(_shares);
        _balances[msg.sender] = _balances[msg.sender].add(_shares);
        emit Staked(msg.sender, _shares);
    }

    function unstake(uint256 _amount) public {
        getReward();
        if (_amount > 0) {
            _totalSupply = _totalSupply.sub(_amount);
            require(_balances[msg.sender] >= _amount, "stakedBal < _amount");
            _balances[msg.sender] = _balances[msg.sender].sub(_amount);  
            IERC20(address(this)).transfer(msg.sender, _amount);
        }
        emit Withdraw(msg.sender, _amount);
    }

// ----------------------------------------------------------------------------
// --- Governance Function
// ----------------------------------------------------------------------------

    function governanceRecoverUnsupported(IERC20 _token, uint256 amount, address to) external {
        require(msg.sender == governance, "!governance");
        require(address(_token) != address(stakingToken), "token");
        require(address(_token) != address(this), "share");
        _token.safeTransfer(to, amount);
    }

    event NotifyReward(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
}