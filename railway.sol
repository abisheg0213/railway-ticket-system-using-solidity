pragma solidity ^0.8.14;
contract railway
{
    uint ticket_id=1020;
    uint refund_id=1;
    uint [20] nonac;
    uint [15] ac;
    uint public totalincome;
    uint nonac_rate=150;
    uint ac_rate=450;
    uint nonac_avail=20;
    uint ac_avail=15;
    address[] users;
    uint[] btk;
    struct ticket_booked
    {
        address p;
        uint coach;
        uint[] seat_no;
        uint total_amount_spend;
        uint time;
    }
    struct refund
    {
        uint t_id;
        uint refund_amount;
        uint time;
    }
    mapping(uint => ticket_booked) public tb;
     mapping(uint => refund) public refunds;
    function setval() private{
        for(uint i=0;i<20;i++)
        {
            nonac[i]=0;
        }
          for(uint i=0;i<15;i++)
        {
            ac[i]=0;
        }
    }
    constructor()
    {
        setval();
    }
    function availablity(uint coach,uint y) public view returns(bool)
    {
        bool res=false;
        if(coach==101)
        {
            if(ac_avail>=y)
            {
                res=true;
            }
        }
        if(coach==102)
        {
            if(nonac_avail>=y)
            {
                res=true;
            }
        }
        return res;
    }
    function reg_user() public
    {
        users.push(msg.sender);
    }
    function ret_current_seat(uint c) private returns(uint)
    {
        uint t;
        if(c==102)
        {
            for(uint i=0;i<20;i++)
            {
                if(nonac[i]==0)
                {
                    t=i;
                    break;
                }
            }
        }
         if(c==101)
        {
            for(uint i=0;i<15;i++)
            {
                if(ac[i]==0)
                {
                    t=i;
                    break;
                }
            }
        }
        return t;
    }
    function vaild_user(address r) private returns(bool)
    {
        uint y=0;
        bool avail;
        for(uint i=0;i<users.length;i++)
        {
            // v=i;
            if(users[i]==r)
            {
                avail=true;
                y=1;
            }
        }
        if (y==0)
        {
            avail=false;
        }
        return avail;
    }
    modifier val_user(address k)
    {
        require(vaild_user(k)==true);
        _;
    }
    function book_tickets(uint c,uint no) public val_user(msg.sender)
    {
        for(uint i=0;i<btk.length;i++)
        {
            btk.pop();
        }
        uint ty=ret_current_seat(c);
        if(c==102)
        {
            for(uint u=0;u<no;u++)
            {
                btk.push(ty+u);
                nonac[ty+u]=1;
            }
            totalincome+=(no*nonac_rate);
            tb[ticket_id]=(ticket_booked(msg.sender,c,btk,no*nonac_rate,block.timestamp));
            ticket_id++;
            nonac_avail-=no;
        }
        if(c==101)
        {
            for(uint u=0;u<no;u++)
            {
                btk.push(ty+u);
                ac[ty+u]=1;
            }
            totalincome+=(no*ac_rate);
            tb[ticket_id]=(ticket_booked(msg.sender,c,btk,no*ac_rate,block.timestamp));
            ticket_id++;
            ac_avail-=no;
        }
    }
    function cancel_ticket(uint id,uint c) public
    {
        uint tp=tb[id].total_amount_spend;
        uint am=tp-225;
        refunds[refund_id]=refund(id,am,block.timestamp);
        totalincome=totalincome-am;
        if(c==101)
        {
        for(uint i=0;i<tb[id].seat_no.length;i++)
        {
            ac[tb[id].seat_no[i]]=0;
        }
        }
        if(c==102)
        {
        for(uint i=0;i<tb[id].seat_no.length;i++)
        {
            nonac[tb[id].seat_no[i]]=0;
        }
        }
    }
}
