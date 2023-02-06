<div align= >
   

# <img align=center width=85px  src="https://media0.giphy.com/media/idjnnqxEInAPn8elMd/giphy.gif?cid=790b761139e83663458cbb2b9508ae1ad8b5f85fab058fe7&rid=giphy.gif&ct=s"> Pipelined Processor



</div>
<div align="center">
   <img align="center"  width="650px" src="https://cdn.dribbble.com/users/1366606/screenshots/8075231/dribbble-003.gif" alt="logo">


### ”Lets Go, Start New Adventure.⚡“
   
</div>
 
<p align="center"> 
    <br> 
</p>

## <img align= center width=50px height=50px src="https://thumbs.gfycat.com/HeftyDescriptiveChimneyswift-size_restricted.gif"> Table of Contents

- <a href ="#about"> 📙 Overview</a>
    - <a href ="#memory">💾 Memory units and register description</a>
    - <a href ="#isa">💻 ISA specifications</a>
- <a href ="#started"> 🚀 Get Started</a>
- <a href ="#contributors"> ✨ Contributors</a>
- <a href ="#license"> 🔒 License</a>
<hr style="background-color: #4b4c60"></hr>

## <img align="center"    height =50px src="https://user-images.githubusercontent.com/71986226/154076110-1233d7a8-92c2-4d79-82c1-30e278aa518a.gif"> Overview <a id = "about"></a>

<ul>
<li>
It is required to design, implement and test a Harvard (separate memories
for data and instructions), RISC-like, five-stages pipeline processor, with the specifications as described in the following sections
</li>
</ul>
<div align="center"  ><hr width="60%">
</div>

### <img align="center"   height =70px src="https://media4.giphy.com/media/28aHBTsyyuOSweunHR/200w.webp?cid=ecf05e4730rzgakmz1fmie707qdqtk83x7q0cvj030f7sa7k&rid=200w.webp&ct=s"> Memory units and registers description <a id = "memory"></a>


<ul>
<li>In this project, we apply a Harvard architecture with two memory units; Instructions’ memory and Data
memory.</li>
<li>The processor in this project has a RISC-like instruction set architecture. There are eight 2-bytes general 
purpose registers[ R0 to R7]. These registers are separate from the program counter and the stack pointer 
registers.</li>
<li>The program counter (PC) spans the instructions memory address space that has a total size of 2
Megabytes. Each memory address has a 16-bit width (i.e., is word addressable). The instructions memory 
starts with the interrupts area (the very first address space from [0 down to 2^5 -1]), followed by the 
instructions area (starting from [2^5
and down to 2^20]) as shown in Figure.1. By default, the PC is initialized 
with a value of (2
5
) where the program code starts.</li>
<li>The other memory unit is the data memory, which has a total size of 4 Kilobytes for its own, 16-bit in width
(i.e., is word addressable). The processor can access both memory units at the same time without having 
a memory access hazard.</li>
<li>The data memory starts with the data area (the very first address space and down), followed by the stack 
area (starting from [2^11 − 1 and up]) as shown in Figure.1. By default, the stack pointer (SP) pointer points 
to the top of the stack (the next free address available in the stack), and is initialized by a value of (2^11 -1).</li>
<li>When an interrupt occurs, the processor finishes the currently fetched instructions (instructions that 
have already entered the pipeline), save the processor state (Flags), then the address of the next 
instruction (in PC) is saved on top of the stack, and PC is loaded from address 0 of the memory where 
the interrupt code resides. </li>
<li>For simplicity reasons, we will have only one interrupt program, the one which starts at the top of the 
instruction’s memory, but be aware of possible nested interrupts i.e., an interrupt might be raised while 
executing an interrupt, and your processor should handle all of them successfully. </li>
<li>To return from an interrupt, an RTI instruction loads the PC from the top of stack, restores the processor 
state (Flags), and the flow of the program resumes from the instruction that was supposed to be fetched 
in-order before handling the interrupted instruction. Take care of corner cases like Branching </li>

</ul>
<hr style="background-color: #4b4c60"></hr>

### <img align="center"   height =70px src="https://media4.giphy.com/media/28aHBTsyyuOSweunHR/200w.webp?cid=ecf05e4730rzgakmz1fmie707qdqtk83x7q0cvj030f7sa7k&rid=200w.webp&ct=s"> ISA specifications <a id = "isa"></a>


<hr style="background-color: #4b4c60"></hr>

## <img  align= center width=50px height=50px src="https://c.tenor.com/HgX89Yku5V4AAAAi/to-the-moon.gif"> Get Started <a id = "started"></a>

<ol>
<li>Clone the repository

<br>

```sh
git clone https://github.com/AdhamAliAbdelAal/Pipelined-Processor
```

</li>
<li>Put your test cases in "code.asm"

<br>

```sh
 cd './Assembler/code.asm'
```
</li>
<li>Run

<br>

``` sh
python ./Assembler/assembler.py
```
</li>
<li>Main file is

<br>

```sh
 cd './Codes/Processor.v'
```
</li>
<li>There are more test cases in folder

<br>

```sh
 cd './Assembler/TestCases'
```
</li>
</ol>
<hr style="background-color: #4b4c60"></hr>



## <img  align= center width= 80px height =80px src="https://media2.giphy.com/media/r0xXyasMMP3MA493e2/giphy.gif?cid=ecf05e47zzldel3l1zcdf08jibtto03qcwidkegx0itev1fd&rid=giphy.gif&ct=s">  Build & Deployment <a id ="deployment"></a>

There are a few additional environment variables that are used when building and deploying for production.

1. `REACT_APP_GOOGLECLIENTID`: A environment string used in connecting with google client.
1. `REACT_APP_FACEBOOKCLIENTID`:A environment string used in connecting with facebook client.
1. `REACT_APP_SITEKEY`: A environment string used in google captcha..
1. `REACT_APP_ENV`:  An environment string. Currently it is only used to differentiate different deploys (development or production).
1. `REACT_APP_PROXY_DEVELOPMENT`: The base URL of the development server. default value is `http://localhost:8000`.
1. `REACT_APP_PROXY_PRODUCTION`: The base URL of the backend


<hr style="background-color: #4b4c60"></hr>



## <img  align= center width= 70px height =70px src="https://media1.giphy.com/media/NnSFnC428LRHaxUNzj/giphy.gif?cid=ecf05e47r1hlw9wrf1swakc9gxgn508lyzvbyzgp9i1iyvwl&rid=giphy.gif&ct=s"> Features  <a id ="features"></a>


<div align="center">
   <img align="center" width="600px" src="https://user-images.githubusercontent.com/71986226/214973107-694909ea-3fbc-471c-8a2f-adbd7bbe5656.png" alt="Features">
   
</div>
<hr style="background-color: #4b4c60"></hr>

<table align="left;">
<tr>
<th width=20%>Feature</th>
<th width=40%>ScreenShot</th>
<th>Description</th>
</tr>
<tr>
<td>
🔷 Authentication
</td>
<td>

   <img align="center"  src="https://user-images.githubusercontent.com/71986226/214926073-f15e5b52-9752-4b19-b5e8-c174c0c37e9f.png" alt="logo">
</td>
<td>
<ul>
<li>Login</li>
<li>Sign-up</li>
<li>Sign-up with Google and Facebook</li>
<li>Reset Password</li>
<li>Forget User Name</li>
</ul>
</td>
</tr>
<tr>
<td>🔶 Create Post</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214927486-0d758927-af11-444d-811b-50b1a95953ec.png" alt="logo">
</td>
<td>

<p>1) You con create 3 types of post</p>
<ul>
<li>📝 Text: you can add text and styling it with fancy text editor</li>
<li>📷 Image: you can upload photo or video to add to your post</li>
<li>📎 Link: you can add link to your post</li>
</ul>
<p>2) You con add 2 tag to your post</p>
<ul>
<li>🔞 NSFW</li>
<li>💥 spoiler</li>
</ul>
</td>
</tr>
<tr>
<td>🔷 Search</td>
<td>

   <img align="center"   src="https://user-images.githubusercontent.com/71986226/214928486-b004a587-072b-4e4d-99c1-82c9b232f248.png" alt="logo">
</td>
<td><p>The search results have 4 types</p> 
<ul>
<li>📫 Posts</li>
<li>💭 Comments</li>
<li>👨‍👧 Communities</li>
<li>👨‍👨‍👦‍👦 People</li>
</ul>
</td>
</tr>
<tr>
<td>🔶 User Actions</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214938211-46ed9004-afc9-4739-988a-946e0a78cc99.png" alt="logo">
</td>
<td>
<p>You con do actions on posts like</p>
<ul>
<li>⏏ Upvote & Downvote</li>
<li>⤴ Share</li>
<li>✒ Edit post</li>
<li>✅ Approve (if you are moderator)</li>
<li>🕳 Spam</li>
<li>🙈 Hidden</li>
<li>🔱 Save</li>
<li>🚫 Delete (if you are moderator or creator post)</li>
<li>🔒 Lock (if you are moderator or creator post)</li>
</ul>
</td>
</tr>
</tr>
<tr>
<td>🔷 Comments</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214938584-6b44cb0c-6476-49db-adb2-60915d16a611.png" alt="logo">
</td>
<td>
<p>1) 🖇 Multilevel Comments</p>
<p>3) Actions on posts:</p>
<ul>
<li>⏏ Upvote & Downvote</li>
<li>✅ Approve (if you are moderator)</li>
<li>🕳 Spam</li>
<li>🔱 Save</li>
<li>🗯 Replay</li>
</ul>
</td>
</tr>
<tr>
<td>🔶 Settings</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214939016-54daf788-41aa-463e-8c9d-0109e76183bb.png" alt="logo">
</td>
<td>
<ul>
<li>
<p>🚹 Account</p>
<ul>
<li><p>You can change (Email, Password, Gender, Country)</li>
<li>
<p> Delete Account</p></li>
<li>
<p>Connect with google </p></li>
</ul>
</li>
<li>
<p>👤 Profile</p>
<ul>
<li><p>You can Edit (name , about, Profile picture, Background Picture) </p></li>
<li>
<p>You can on/off (NSFW, allow people to follow you)</p></li>
<li>
<p>You can add  social links to other website </p></li>
</ul>
</li>
</li>
<li>
<p>🚨 Safety and privacy</p>
<ul>
<li><p>🔈 You can block and unblock user  </p></li>
<li>
<p>You can see block list</p></li>
</ul>
</li>
</li>
<li>
<p>⚡ Feed Settings</p>
<ul>
<li><p>You can on/off (Adult content, autoplay media)</p></li>
</ul>
</li>
</ul>
</td>
</tr>
<tr>
<td>🔷 Notifications</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214939180-a2379ced-8a3e-4009-ba31-7711c6a0104f.png" alt="logo">
</td>
<td>
<p>1) 🙈 You con hide notification </p>
<p>2) Types Notification:</p>
<ul>
<li>New Followers</li>
<li>Replies</li>
</ul>
</td>
</tr>
</tr>
<tr>
<td>🔶 Profile</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214939374-1d31bfd4-6385-437c-9b11-dde2cdc44c48.png" alt="logo">
</td>
<td>
<p>You con view </p>
<ul>
<li>🏔 Overview: you can see activity of user</li>
<li>📫 Posts: you can see posts of user</li>
<li>🗯 Comments: you can see comments of user</li>
<li>🗃 History: posts just yo see it</li>
<li>📋 Saved: posts and comments you saved it</li>
<li>🙈 Hidden: posts you hide it </li>
<li>👍 Upvote: posts you upvote it </li>
<li>👎 Downvote:  posts you downvote it</li>
</ul>
</td>
</tr>
<td>🔷 Subreddit</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214939616-d6d37452-5cd0-4171-897a-1dbbaa821580.png" alt="logo">
</td>
<td>
<p>1) 🔰 You con create Subreddit</p>
<p>2) 👀 View posts of Subreddit</p>
<p>3) 🤜🏼 join or leave Subreddit</p>
<p>4) Subreddit types:</p>
<ul>
<li>👷🏼‍♂️ Public: Anyone can view, post, and comment to this community</li>
<li>👁‍🗨 Restricted: Anyone can view this community, but only approved users can post</li>
<li>🔒 Private: Only approved users can view and submit to this community</li>
</ul>
</td>
</tr>
<tr>
<td>🔶 Moderation</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214939838-fa3a4dcc-df2e-495f-8e3d-04057205e492.png" alt="logo">
</td>
<td>
<p>In Moderation  page, you can control:</p>
<ul>
<li>🕳 Spam: you can control spam posts</li>
<li>✒ Edited: you can control edited posts</li>
<li>💈 Unmoderator: you can control unmoderator posts</li>
<li>🚫 BANNED: you can ban users</li>
<li>🔈 MUTED:  you can mute users</li>
<li>✅ APPROVED: you can add new moderators </li>
<li>👨🏽‍🤝‍👨🏻 MODERATORS: you can edit access to moderators</li>
<li>🎨 POST FLAIR: you can edit flair and make new flairs</li>
<li>🚧 RULES: you can add new rules to subreddit</li>
<li>👨‍👨‍👦‍👦 COMMUNITY: you can edit (name of subreddit, community topics, community description, region, type of community)</li>
<li>💭 POSTS AND COMMENTS: you can control type of posts</li>
</ul>
</td>
</tr>
<tr>
<td>🔷 Messages</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214940032-6eae117f-b5cb-4f67-84f1-da6920706e79.png" alt="logo">
</td>
<td>
<p>1) 📩 Message Form (Send a private message)</p>
<p>2) 📮 Sent Messages: message which you sent</p>
<p>3) 📦 Inbox :</p>
<ul>
<li>All: All messages</li>
<li>Unread: message which you didn't read it</li>
<li>Messages : message which you receive</li>
<li>Post replies: replies to your posts</li>
</ul>
</td>
</tr>
<tr>
<td>🔶 Push Notifications</td>
<td align="center">

<img align="center" width="50%" src="https://user-images.githubusercontent.com/71986226/214954696-9ec0850c-a802-4a71-b186-1c642ec1df79.png" alt="logo">
</td>
<td>
<p>1) 💌 Notifications and messages </p>
<p>2) 🔓 You must give permission to push notifications</p>
<p>3) Push Notifications types:</p>
<ul>
<li>Foreground</li>
<li>Background</li>
</ul>
</td>
</tr>
</tr>
<tr>
<td>🔷 Top Communities</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214940837-d0a539da-e609-45f4-a010-aaf1949d82a6.png" alt="logo">
</td>
<td>
<p>👨‍👨‍👧‍👧 View top  communities by categories</p>
</td>
</tr>
<tr>
<td>🔶 Pages</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214940238-c127ed56-3b07-4e3e-a8b7-6cc3a49595e3.png" alt="logo">
</td>
<td>
<ul>
<li>
<p>Home page </p>
</li>
<li>
<p>Popular</p></li>
<li>
<p>ALL</p></li>
<li>
<p>Explorer</p></li>
</ul>
</td>
</tr>
<tr>
<td>🔷 Listing</td>
<td>

<img align="center" src="https://user-images.githubusercontent.com/71986226/214940399-25af19f6-6d91-4fcf-9422-d1d3159910a2.png" alt="logo">
</td>
<td>
<p>You can sort posts </p>
<ul>
<li>Hot</li>
<li>Top</li>
<li>New</li>
<li>Hot</li>
</ul>
</td>
</tr>
</table>

<hr style="background-color: #4b4c60"></hr>


## <img  align= center width= 70px height =70px src="https://img.genial.ly/5f91608064ad990c6ee12237/bd7195a3-a8bb-494b-8a6d-af48dd4deb4b.gif?genial&1643587200063">  GIF Demo <a id ="video"></a>

<table align="left;">
<tr>
<th>Video</th>
<th>Content</th>
</tr>
<tr>
<td  width="83.5%">
<video src="https://user-images.githubusercontent.com/71986226/214705509-cb1f10bb-aab2-4252-843b-57249bc10ed3.mp4"   >
</video> 
</td>
<td >
<ul>
<li>Authentication</li>
<li>Comments</li>
<li>Notification</li>
<li>Messages</li>
<li>Settings</li>
</ul>
</td>
</tr>
</table>
<hr style="background-color: #4b4c60"></hr>
<table align="left;">
<tr>
<td width="80.5%">
<video src="https://user-images.githubusercontent.com/71986226/214708909-fccfd917-f8bb-4166-a76d-de1248faa2bd.mp4"   >
</video> 
</td>
<td >
<ul>
<li>Home page</li>
<li>Posts</li>
<li>Create Post</li>
</ul>
</td>
</td>
</tr>
</table>
<hr style="background-color: #4b4c60"></hr>
<table align="left;">
<tr>
<td width="83.5%">
<video src="https://user-images.githubusercontent.com/71986226/214707390-e21e2c04-08b2-4319-bb1e-7a3cd6316bc4.mp4"   >
</video> 
</td>
<td   >
<ul>
<li>My profile</li>
<li>Other Profile</li>
<li>Moderation</li>
<li>Top Communities</li>
</ul>
</td>
</tr>
</tr>
</table>
<hr style="background-color: #4b4c60"></hr>
<table align="left;">
<tr >
<td  width="83.5%">
<video src="https://user-images.githubusercontent.com/71986226/214714497-83c68943-4ced-4116-a06d-7830b0e0607d.mp4"   >
</video> 
</td>
<td >
<ul>
<li>Create Subreddit</li>
<li>Subreddit</li>
<li>Moderation</li>
<li>Search</li>
<li>Explorer</li>
</ul>
</td>
</tr>
</table>



<hr style="background-color: #4b4c60"></hr>

## <img  align="center" width= 70px height =55px src="https://media0.giphy.com/media/Xy702eMOiGGPzk4Zkd/giphy.gif?cid=ecf05e475vmf48k83bvzye3w2m2xl03iyem3tkuw2krpkb7k&rid=giphy.gif&ct=s"> Contributors <a id ="contributors"></a>

<table align="center" >
  <tr>
     <td align="center"><a href="https://github.com/khaled-farahat"><img src="https://avatars.githubusercontent.com/u/84389471?v=4" width="150px;" alt=""/><br /><sub><b>khaled Farahat</b></sub></a><br /></td>
    <td align="center"><a href="https://github.com/AdhamAliAbdelAal" ><img src="https://avatars.githubusercontent.com/u/83884426?v=4" width="150px;" alt=""/><br /><sub><b>Adham Ali</b></sub></a><br />
    </td>
      <td align="center"><a href="https://github.com/MohamedWw"><img src="https://avatars.githubusercontent.com/u/64079821?v=4" width="150px;" alt=""/><br /><sub><b>Mohamed Walid</b></sub></a><br /></td>
     <td align="center"><a href="https://github.com/EslamAsHhraf"><img src="https://avatars.githubusercontent.com/u/71986226?v=4" width="150px;" alt=""/><br /><sub><b>Eslam Ashraf</b></sub></a><br /></td>
  </tr>
</table>

## 🔒 License <a id ="license"></a>

> **Note**: This software is licensed under MIT License, See [License](https://github.com/NonLegit/Front-End/blob/development/LICENSE) for more information ©Adham Ali.
