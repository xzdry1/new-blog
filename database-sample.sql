DROP DATABASE IF EXISTS blog;

CREATE DATABASE blog;
use blog;

CREATE TABLE category(
    category_id BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100)
);

INSERT INTO category(category.category_name) VALUES
("笔记"), ("计算机"), ("计算器"), ("杂类"), ("坑");

CREATE TABLE widget(
    widget_id BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    widget_content TEXT,
    widget_isEnabled INT NOT NULL DEFAULT 1
);

INSERT INTO widget(widget_content) VALUES(
    '<div style="font-size: 1.2em; margin-bottom: 8px;">Links</div>\n'
    '<div style="border-bottom: solid 1px black; margin-bottom: 2px; padding-bottom: 2px;">\n'
    '	<a href="https://www.ntzyz.cn/" target="_blank">About me</a><br />\n'
    '	<a href="https://blog.dimension.moe/minecraft/" target="_blank">Minecraft</a><br />\n'
    '</div>\n'
    '<div>\n'
    '	<a title="JerryFu\'s Blog" href="http://www.jerryfu.net/" target="_black">JerryFu\'s Blog</a><br />\n'
    '	<a title="Enrichment Center" href="http://tonoko.zz.mu/" target="_blank">Enrichment Center</a><br />\n'
    '	<a title="春上冰月的博客" href="http://haruue.moe/" target="_blank">春上冰月的博客</a><br />\n'
    '	<del><a title="Uiharu\'s Garden — 初春静流的花园" href="http://uiharu.sinaapp.com" target="_blank">Uiharu\'s Garden</a></del><br />\n'
    '	<a title=">Lithia\'s Core" href="http://lithcore.cn/" target="_blank">&gt;Lithia\'s Core</a><br />\n'
    '	<a title="ZephRay" href="http://zephray.com/" target="_blank">ZephRay</a><br />\n'
    '	<a title="kasora\'s blog" href="https://blog.kasora.moe/" target="_blank">kasora\'s blog</a><br />\n'
    '	<a title="Test2g" href="https://www.test2g.xyz/" target="_blank">Test2g</a><br />\n'
    '	<a title="苍崎橙子" href="http://ao.acg.ac/" target="_blank">苍崎橙子</a><br />\n'
    '	<a title="R-C\'s Blog" href="http://blog.r-c.im/" target="_blank">RiCE Blog</a><br />\n'
    '	<a title="Shell Bin" href="http://shellbin.top/" target="_blank">Shell Bin</a>\n'
    '</div>\n'
);

CREATE TABLE user(
    user_id BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    user_name VARCHAR(200) NOT NULL,
    user_pass VARCHAR(200) NOT NULL
);
INSERT INTO user(user_name, user_pass) VALUES (
    'ntzyz', '24aa57a0b8614a5fb6bb7dae52695dbf'
);

/* render_type:
 *     0 -> HTML
 *     1 -> Jade(pug)
 *     2 -> Markdown
 */
CREATE TABLE post(
    post_id BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    post_title TEXT,
    post_content TEXT,
    post_date VARCHAR(20),
    post_category_id BIGINT,
    post_shot TEXT,
    render_type INT DEFAULT 0
);

INSERT INTO post(post_title, post_content, post_date, post_category_id, post_shot) VALUES
(
    "[WebGL] 简单的 WebGL 描点实现",
    '<style type="text/css">\n'
    'p.indent {text-indent: 2em;margin-top: 0.75em; margin-bottom: 0.75em;}\n'
    '</style>\n'
    '<p class="indent">相关库的地址：<a href="https://github.com/yukoba/WebGLBook/tree/master/lib" target="_blank">WebGLBook/lib at master</a></p>\n'
    '<p class="indent">效果预览见最后。</p>\n'
    '<p class="indent">注意：这只是个人的理解，不保证正确。如有错误欢迎指正！</p>\n'
    '<p class="indent">首先准备具有一个画布（canvas）的页面，所有的 WebGL 程序都会通过这个 canvas 展现出来：</p>\n'
    '<code><!doctype html>\n'
    '<html>\n'
    '    <head>\n'
    '        <meta charset="utf-8" />\n'
    '        <title>Hello Canvas</title>\n'
    '    </head>\n'
    '    <body style="background-color: #222;">\n'
    '        <canvas id="webgl" width="400" height="400" style="margin: 100px;">\n'
    '            你可能是正版IE的受害者。\n'
    '        </canvas>\n'
    '        <script src="libs/webgl-utils.js"></script>\n'
    '        <script src="libs/webgl-debug.js"></script>\n'
    '        <script src="libs/cuon-utils.js"></script>\n'
    '        <script src="libs/cuon-matrix.js"></script>\n'
    '        <script src="app.js"></script>\n'
    '    </body>\n'
    '</html></code>\n'
    '<p class="indent">然后就是 app.js，即实现描点的相关代码。通过 DOM 操作，可以很容易地获得 canvas 的 DOM 节点，进而获得 WebGL 的上下文：</p>\n'
    '<code>    var canvas = document.getElementById(\'webgl\');\n'
    '    var gl = getWebGLContext(canvas);\n'
    '    if (!gl) {\n'
    '        console.log(\'Error on getting context of WebGL\');\n'
    '        return;\n'
    '    }</code>\n'
    '<p class="indent">初始化完毕后，分别准备顶点着色器和片元着色器的GLSL ES代码。值得注意的是，JavaScript 是一个弱类型的语言，但 GLSL ES 不是，所以不能手滑将 0.0 写成 0，否则会出现类型错误。</p>\n'
    '<p class="indent">在每一行 GLSL ES 代码后添加换行符 \'\n\' 后可以在发生错误时输出行号，降低调试难度。当然，不写也是完全可以的。</p>\n'
    '<code>    var VSHADER_SOURCE =\n'
    '        \'void main() {\' +\n'
    '        \'    gl_Position = vec4(0.0, 0.0, 0.0, 1.0);\' +\n'
    '        \'    gl_PointSize = 10.0;\' +\n'
    '        \'}\';\n'
    '    var FSHADER_SOURCE =\n'
    '        \'void main() {\' +\n'
    '        \'    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);\' +\n'
    '        \'}\';\n'
    '</code>\n'
    '<p class="indent">继续初始化 shader：</p>\n'
    '<code>    if (!initShaders(gl, VSHADER_SOURCE, FSHADER_SOURCE)) {\n'
    '        console.log(\'Error on initialize shaders.\');\n'
    '        return;\n'
    '    }</code>\n'
    '<p class="indent">设置画布默认空颜色，并清空画布：</p>\n'
    '<code>    gl.clearColor(0, 0, 0, 1);\n'
    '    gl.clear(gl.COLOR_BUFFER_BIT);\n'
    '</code>\n'
    '<p class="indent">然后，描点：</p>\n'
    '<code>    gl.drawArrays(gl.POINT, 0, 1);</code>\n'
    '<p class="indent">简单说说我的理解吧。这些代码里获得 GL 上下文没啥好说的，主要的问题就在着色器（Shader）。此处一共出现了两个着色器：顶点着色器、片元着色器。描绘一个点所必须提供的参数就是点的位置与颜色，可以认为这里的顶点着色器指明了点的位置，而片元着色器则指明了其颜色。</p>\n'
    '<p class="indent">顶点着色器代码 VSHADER_SOURCE 中有一个 main 函数，其中存在两个变量。其中 gl_Position 是一个四维向量，由四个浮点分量组成，是一个齐次坐标。其次坐标[x, y, z, w]等价于通常理解的[x/w, y/w, z/w]。使用齐次坐标进行三维处理可以获得更高的效率（？）。此处将 w 分量置为 1.0，即可将齐次坐标直接当成三位笛卡尔坐标使用。第二个变量 gl_PointSize，指明了点的大小。</p>\n'
    '<p class="indent">片元着色器中只存在一个变量：gl_FragColor。它也是一个四维的矢量，其意义分别为红、绿、蓝与透明度的值。与常规的表示方法不同，GL 使用[0, 1]来表示单个颜色的强度，例如[0., 0., 0., 0.]表明了完全透明黑色，而[1., 1., 1., 1.]则表明完全不透明白色。</p>\n'
    '<p class="indent">清空画布后，我们使用了 gl.drawArrays 来描点，其本质就是执行着色器代码。三个参数的意义分别为 描绘类型，从哪个点开始描绘，以及描绘的次数。当此函数被调用时，顶点着色器将会被执行 n 次，顶点着色器代码执行完毕后立即执行片元着色器。全部完成后，就可以看到灰色屏幕中的黑色画布里，描绘了一个红色的点。</p>\n'
    '<p class="indent"><del>顺便这哪里是点啊 这么大明明就是个正方形了嘛好伐）</del></p>\n'
    '<!--more-->\n'
    '<p class="indent">效果预览~</p>\n'
    '<img src="https://blog.dimension.moe/wp-content/uploads/QQ截图20160408000243.png" alt="QQ截图20160408000243" class="aligncenter size-full wp-image-398" />\n',
    '160716', '1',
    '相关库的地址：https://github.com/yukoba/WebGLBook/tree/master/lib [...]'
),(
    "[Node.js] 学校网关登陆脚本",
    '<style type="text/css">\n'
    '.indent {text-indent: 2em;margin-top: 0.75em; margin-bottom: 0.75em;}\n'
    '</style>\n'
    '<p class="indent">虽然现在我在的学校很辣鸡，但是偶然间发现所有的教学区设备，在通过网关认证后，就可以获得一个江苏省常州市教育网的公网 IP 地址，同时拥有 10Mbps 的上下对等带宽，还是蛮良心的（</p>\n'
    '<p class="indent">然后我们就在某办公室内放置了一个配置极其破烂的台式机，用来转发内网端口，VPN 远程接入和其他奇奇怪怪的服务。然而所有这些的前提就是通过了网关认证。比较尴尬的是那台电脑并没有显示器，所以我们只能想其他办法实现这一步骤。</p>\n'
    '<p class="indent">最初我们使用了 VPN ——搭建一个 PPTP VPN 服务器并配置好 NAT 和 IP Forward，然后在内网使用 PPTP 连接至服务器，打开浏览器访问任意非 SSL 网站，就会被 Redirect 到网关认证，然后浏览器里操作就可以完成了。</p>\n'
    '<p class="indent">后来发现 PPTP 的配置实在是比较繁琐（虽然比较其他形式的 VPN，PPTP 是搭建最快速的一个），同时存在各种各样的问题导致 PPP 认证不通过，进而无法建立 PPTP 连接，我们开始改用 Shadowsocks，在需要认证的机器上搭建一个 ss-server，在内网的其他机器上配置好 Shadowsocks 客户端，就可以和 PPTP 一样进行操作了。</p>\n'
    '<p class="indent">再后来发现 Shadowsocks 的编译还是要准备一堆依赖，配置也不足够简单。反思 PPTP，我们使用 PPTP 的目的就是将两个机器组成一个虚拟专用网络，然后所有流量从待认证机器出去以实现认证。仔细想想不难发现其实我们用来认证的机器和待认证机器本来就在一个网段了，为什么还要专门组一个呢？（智商-10）所以我们只需要在待认证服务器上执行这句 iptables 语句：</p>\n'
    '<code>iptables -t nat -A POSTROUTING -s 219.230.153.0/24 -j MASQUERADE</code>\n'
    '<p class="indent">然后再另一个设备上，将默认网关调整至待认证设备IP，就可以和之前一样操作并通过认证了。</p>\n'
    '<p class="indent">今天在数据结构上机的时候，突然想到，我们进行网关的认证，其实就是在网页上填写一个表单，并提交这个表单到认证服务器，随后就解锁了国际互联网访问。那为什么要搞的这么复杂绕了一大圈就为了进行一个 POST 呢？（智商+10）</p>\n'
    '<p class="indent">想到这些就随后几分钟写了段 JavaScript，来实现这些个操作，实测可行。代码如下：</p>\n'
    '<code lang="javascript">\n'
    'var request = require(\'request\');\n'
    'request = request.defaults({jar: true});\n'
    '\n'
    '// Your login info here.\n'
    'var uname = \'\';\n'
    'var passwd = \'\';\n'
    '\n'
    'request.get(\'http://www.bilibili.com/\', (err, res, body) => {\n'
    '    var loginURL = body.substr(28, body.length - 38);\n'
    '    request.get(loginURL, (err, res, body) => {\n'
    '        request.post({\n'
    '            url: \'http://219.230.159.25/eportal/webgateuser.do?method=login_ajax_pure_internet&param=true&\' + loginURL.substr(40) + \'&username=\' + uname + \'&pwd=\' + passwd,\n'
    '            form: {\n'
    '                is_auto_land: false,\n'
    '                usernameHidden: uname,\n'
    '                username_tip: \'Username\',\n'
    '                username: uname,\n'
    '                strTypeAu:null,\n'
    '                uuidQrCode:null,\n'
    '                authorMode:null,\n'
    '                pwd_tip: \'Password\',\n'
    '                pwd: passwd\n'
    '            },\n'
    '            referer: loginURL,\n'
    '            headers: {\n'
    '                \'user-agent\': \'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36\',\n'
    '                \'Connection\': \'keep-alive\',\n'
    '                \'accept\': \'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\',\n'
    '                \'Accept-Encoding\': \'gzip, deflate\',\n'
    '                \'Accept-Language\': \'zh,zh-CN;q=0.8,en-US;q=0.6,en;q=0.4\'\n'
    '            }\n'
    '        }, (err, res, body) => {\n'
    '            if (res.caseless.dict[\'auth-result\'] == \'success\') {\n'
    '                console.log(\'Login Success.\');\n'
    '            }\n'
    '            else {\n'
    '                console.log(\'Something happened.\');\n'
    '            }\n'
    '        });\n'
    '    })\n'
    '})\n'
    '</code>\n'
    '<p class="indent">这段代码需要一个叫 `request` 的依赖，直接输入 `npm insall request` 即可完成安装。将个人的登录信息修改好后，执行脚本：`node login.js`，如果看到输出`Login Success.`，就表明认证通过，可以开始上网啦（（</p>\n'
    '<p class="indent"><del datetime="2016-06-05T04:00:49+00:00">现在看来当时的解决方案真是智障（不）</del></p>\n',
    '160605',
    '2',
    '虽然现在我在的学校很辣鸡，但是偶然间发现所有的教学区设备，在通过网关认证后，就可以获得一个江苏省常州市教育网的公网 IP 地址，同时拥有 10Mbps 的上下对等带宽，还是蛮良心的 [...]'
),(
    "[ndless] ndless 4.0 环境搭建",
    '<p style="text-indent:2em;">机缘巧合之下，手里又多了个 Ti nspire CX CAS，系统版本为 3.1.0392，还是相当新的一台计算器。</p>\n'
    '<p style="text-indent:2em;">说起来，自从高中毕业后，就没怎么折腾过计算器了。毕竟手机和电脑基本都是随时可用，再加上计算器的弱性能和繁琐的操作，逐渐的也就失去了兴趣。但是当这个计算器刚刚到手的时候，又不由得想搞着玩玩了（</p>\n'
    '<p style="text-indent:2em;">ndless 和 nspire 的关系就不必再述了，具体可以前往 cncalc.org 上查找相关置顶贴，或者直接前往 ndless 的官网了解详情。</p>\n'
    '<p style="text-indent:2em;">我的系统是 Ubuntu 15.10，其他发行版自行调整部分内容～首先是准备一下依赖：</p>\n'
    '<code>\n'
    'sudo apt-get install git build-essential binutils libgmp-dev libmpfr-dev libmpc-dev libssl-dev libpython2.7-dev libboost-program-options-dev\n'
    '</code>\n'
    '<p style="text-indent:2em;">如果编译过程中还出现了依赖相关的错误，缺啥装啥就是了（</p>\n'
    '<p style="text-indent:2em;">再然后是下载源码：</p>\n'
    '<code>\n'
    'git clone --recursive https://github.com/ndless-nspire/Ndless.git\n'
    '</code>\n'
    '<p style="text-indent:2em;">完成之后，就可以开始编译 toolchain 了：</p>\n'
    '<code>\n'
    'cd Ndless/ndless-sdk/toolchain/\n'
    './build_toolchain.sh\n'
    '</code>\n'
    '<p style="text-indent:2em;">编译时间比较长，而且这个过程还蜜汁烧 U，之前还试图在 Cubieboard 4 CC-A80 上搭建环境的，结果负载飚到 32 然后彻底 GG 了（</p>\n'
    '<p style="text-indent:2em;">完成之后，还要再编译 ndless 4.0：</p>\n'
    '<code>\n'
    'cd ../..\n'
    'make -j4\n'
    '</code>\n'
    '<p style="text-indent:2em;">这次的快多了，很快就生成了相关文件。到此为止就顺利地完成了环境的搭建。下面就用 ndless sdk 自带的一个 sample 来测试测试：</p>\n'
    '<code>\n'
    'cd Ndless/ndless-sdk/samples/freetype/\n'
    'make clean\n'
    'make\n'
    '</code>\n'
    '<p style="text-indent:2em;">完成之后，就可以将目录下的 freetype_demo.tns 发送到计算器中，然后直接执行。如果没有什么意外，你会看到一个倾斜的 Droid Sans 字样。</p>\n'
    '\n'
    '<p style="text-indent:2em;">顺便 nNovel Freetype 项目开坑，来补偿当年的各种遗憾。权且当作自娱自乐吧（</p>\n',
    '160507',
    '3',
    '机缘巧合之下，手里又多了个 Ti nspire CX CAS，系统版本为 3.1.0392，还是相当新的一台计算器 ...'
),(
    "恶意满满的世界，你好！",
    "<p>手贱啊手贱，备份好了的数据库没有下载到本地就rebuild了……<br><del>打死我也不用CentOS了，还是Ubuntu好</del><br>罢了罢了，重新再来呗</p>",
    '150726',
    '4',
    '手贱啊手贱，备份好了的数据库没有下载到本地就rebuild了 [...]'
),(
    "[ndless] nNovel",
    '<a href="https://github.com/Zhangyuze/nNovel-Plus" target="_blank">[在 GitHub 上查看]</a><style type="text/css">p.indent { text-indent: 2em;}h5 {font-weight: 700; font-family: 文泉驿微米黑, Microsoft Yahei UI, verdana, arial, sans-serif, Simsun; font-size: 1.2em;}</style><h5>简述</h5><p class="indent">nNovel 是一个运行在 TI-Nspire 系列计算器上的中文文本阅读器。</p><h5>特性</h5><p class="indent">1. 同时兼容黑白屏幕和彩色屏幕的所有 Nspire 计算器。</p><p class="indent">2. 16级灰度字库支持，GBK 编码支持。</p><p class="indent">3. 简单的文本预处理，加快阅读时的翻页速度。</p><p class="indent">4. 阅读过程中的亮度/对比度调节。</p><p class="indent">5. 自动翻页与书签的自动保存。</p><h5>截图</h5><img src="https://raw.githubusercontent.com/Zhangyuze/nNovel-Plus/master/screenshots/1.jpg" alt="Screen1" style="max-width:100%;"><img src="https://raw.githubusercontent.com/Zhangyuze/nNovel-Plus/master/screenshots/2.jpg" alt="Screen2" style="max-width:100%;"><img src="https://raw.githubusercontent.com/Zhangyuze/nNovel-Plus/master/screenshots/3.jpg" alt="Screen3" style="max-width:100%;"><img src="https://raw.githubusercontent.com/Zhangyuze/nNovel-Plus/master/screenshots/4.jpg" alt="Screen4" style="max-width:100%;"><h5>缺点</h5><p class="indent">1. 完全不支持 UTF-8 编码的文本。</p><p class="indent">2. 英文单词在换行时会被切断。</p><p class="indent">3. 不支持自定义颜色和文本大小。</p><p class="indent">4. 不支持修改行间距、字间距与段落间距。</p><h5>下载</h5><p class="indent"><a href="http://www.cncalc.org/thread-9785-1-1.html" target="_blank">前往 cncalc.org</a></p>',
    '160225',
    '5',
    '[在 GitHub 上查看] [...]'
),(
    '[重要！]简单说明',
	'<p>这是一个半成品 Blog，后台使用了 Node.js 和 Express.js，前台目前使用了 Vue.js, Materialize。</p>\n',
    '160729',
    '5',
    '这是一个半成品 Blog，后台使用了 Node.js 和 [...]'
),(
    '[水] Minecraft 服务器周边功能小记',
'<style>\n'
'  p.indent {\n'
'    text-indent: 2em;\n'
'  }\n'
'</style>\n'
'<p class="indent">按照以往运行 Minecraft 服务器的情况，玩家们常常需要一些游戏以外的信息：</p>\n'
'<ul>\n'
'  <li>服务器负载情况</li>\n'
'  <li>服务器是否还活着</li>\n'
'  <li>我<del>是死宅</del>要上传皮肤</li>\n'
'</ul>\n'
'<p class="indent">那么，作为一个不怎么管服务器里发生了什么的管理，我就主动把这些功能实现了一下。其他的游戏内管理就<del>甩</del>交给 <a href="https://blog.kasora.moe/" target="_blank">@kasora</a> 了。</p>\n'
'<h2>服务器负载</h2>\n'
'<p class="indent">我们目前使用的是腾讯机房的双核 4G 的云服务器，讲道理这种阵容并不适合跑 MC 这种单线程大作。与此同时这次服务器应要求添加了村庄Mod（Millenaire），而 Millenaire 的作者自述此 Mod 和 Bukkit 存在兼容性问题，直接导致我们不再能使用 Bukkit 或者是基于 Bukkit 的服务端（例如 Cauldron），进而失去了 Bukkit API 和民间带来的一些优化。于是，在任意时刻知道服务器负荷以及一段时间内的负荷就显得比较有意义了。</p>\n'
'<p class="indent">至于如何去实现，就比较简单了。由于备案之类的种种问题，我们运行着 Minecraft Server 的服务器原则上不可以运行任何 HTTP Server 服务，所以我的思路是本机采集数据，然后通过某些办法发送到另一个已经备案了的服务器。</p>\n'
'<h3>收集数据</h3>\n'
'<p class="indent">在 Linux 设备上，我们有很多途径可以知道设备的负载和内存开销。系统负载的话，比如 `top`、`uptime` 命令，或者是 `/proc/loadavg` 这类文件，同样系统时间和内存占用也不难获得。于是我们可以准备这么一个 shell 脚本：</p>\n'
'<code>\n'
'#!/bin/bash\n'
'\n'
'TIMESTAMP=`date +%s`\n'
'LOAD=`cat /proc/loadavg | awk \'{print $1}\'`\n'
'MEM=`free -m | grep \'Mem\' | awk \'{print $3}\'`\n'
'\n'
'URL="https://status.mc.ntzyz.cn/set.php?timestamp=$TIMESTAMP&mem=$MEM&load=$LOAD"\n'
'\n'
'curl $URL > /dev/null\n'
'</code>\n'
'<p class="indent">执行一次，就能得到当前时间戳，1 分钟内负载和内存使用，并把这些数据作为请求发送到 status.mc.ntzyz.cn 所在的服务器了。这个脚本需要定时执行，使用 `crontab` 就可以完成。执行 `crontab -e`，并在文末添上：</p>\n'
'<code>* * * * * /bin/bash /home/ntzyz/send.sh</code>\n'
'<p class="indent">就可以实现每分钟一次请求了。</p>\n'
'<h3>记录数据</h3>\n'
'<p class="indent">服务器的各种数据发送到 status.mc.ntzyz.cn 之后，就需要将这些数据保存下来，准备随时被需要数据的情况下使用。是时候让全世界最好的语言上场了（雾</p>\n'
'<code>\n'
'<?php\n'
'  if ($_SERVER["REMOTE_ADDR"] != "115.159.105.52") { // 防止某些人用自己的数据没事儿干瞎 GET\n'
'    $res->status = "ERROR";\n'
'    $res->message = "You shall not access.";\n'
'    die(json_encode($res));\n'
'  }\n'
'\n'
'  $conn = mysql_connect("localhost", "_(:3」∠)_", "（╯－＿－）╯╧╧");\n'
'  if (!$conn) {\n'
'    $res->status = "ERROR";\n'
'    $res->message = "Could not connect: " . mysql_error();\n'
'    die(json_encode($res));\n'
'  }\n'
'\n'
'  $mem_used = $_GET["mem"];\n'
'  $cpu_load = $_GET["load"];\n'
'  $timestamp = time();\n'
'  if (!isset($mem_used) || !isset($cpu_load)) {\n'
'    $res->status = "ERROR";\n'
'    $res->message = "required field(s) is empty.";\n'
'    die(json_encode($res));\n'
'  }\n'
'\n'
'  mysql_select_db("mc_stat", $conn);\n'
'  $sql = "insert into mc_stat(timestamp, cpu_load, mem_used) values(\'$timestamp\', \'$cpu_load\', \'$mem_used\')";\n'
'\n'
'  if (!mysql_query($sql,$conn)) {\n'
'    $res->status = "ERROR";\n'
'    $res->message = "SQL Error: " . mysql_error();\n'
'    die(json_encode($res));\n'
'  }\n'
'  else {\n'
'    $res->status = "success";\n'
'    echo(json_encode($res));\n'
'  }\n'
'?>\n'
'</code>\n'
'<p class="indent">这样你就可以将使用 cURL 发来的数据保存到数据库了。然后就是再写一段脚本来读取这些数据，准备让其他人读取。</p>\n'
'<code>\n'
'<?php\n'
'  header("Access-Control-Allow-Origin: *"); // Ajax is GOOD\n'
'  $conn = mysql_connect("localhost", "（╯－＿－）╯╧╧", "_(:3」∠)_");\n'
'  $limit = 15;\n'
'  if (isset($_GET["limit"])) {\n'
'    $limit = $_GET["limit"];\n'
'  }\n'
'\n'
'  if (!$conn) {\n'
'    $res->status = "ERROR";\n'
'    $res->message = "Could not connect: " . mysql_error();\n'
'    die(json_encode($res));\n'
'  }\n'
'\n'
'  mysql_select_db("mc_stat", $conn);\n'
'\n'
'  $res = mysql_query("select * from mc_stat order by timestamp desc limit $limit                                                                              ");\n'
'  $i = 0;\n'
'\n'
'  $resp->status = "success";\n'
'  $resp->data = array();\n'
'\n'
'  while ($row = mysql_fetch_array($res)) {\n'
'    $resp->data[$i]->timestamp = $row["timestamp"];\n'
'    $resp->data[$i]->cpu_load = $row["cpu_load"];\n'
'    $resp->data[$i]->mem_used = $row["mem_used"];\n'
'    $i = $i + 1;\n'
'  }\n'
'\n'
'  die(json_encode($resp));\n'
'?>\n'
'</code>\n'
'<p class="indent">数据的保存和读取就都完成了。</p>\n'
'<h3>显示数据</h3>\n'
'<p class="indent">世界上没什么比图形好的数据可视化方案了。我选择使用 highcharts 这个图表框架。由于只需要简单的显示两张折线图（负载和内存），我就直接对着 Demo 改了改，也算是 Make data come alive 了。</p>\n'
'<p class="indent">两张表的结构基本一致，所以只要准备一份模板，然后两次填入数据并使用框架就行了。首先是模板：</p>\n'
'<code>\n'
'var template = {\n'
'  title: {\n'
'    text: \'Monthly Average Temperature\',\n'
'    x: -20 //center\n'
'  },\n'
'  xAxis: {\n'
'    categories: null\n'
'  },\n'
'  yAxis: {\n'
'    plotLines: [{\n'
'      value: 0,\n'
'      width: 1,\n'
'      color: \'#808080\'\n'
'    }]\n'
'  },\n'
'  tooltip: {\n'
'    valueSuffix: \'\'\n'
'  },\n'
'  legend: {\n'
'    layout: \'vertical\',\n'
'    align: \'right\',\n'
'    verticalAlign: \'middle\',\n'
'    borderWidth: 0\n'
'  },\n'
'  series: [{\n'
'    name: \'Tokyo\',\n'
'    data: []\n'
'  }]\n'
'};\n'
'</code>\n'
'<p class="indent">嗯，稍微了解过 Highcharts 的人都能看出，这基本就是第一个 Demo —— Basic Lines 的内容，只是少了一些个数据。然后就是使用 Ajax，将保存在 status.mc.ntzyz.cn 上的数据获得到浏览器，填入 template 并显示。</p>\n'
'<code>\n'
'  $.ajax({\n'
'    url: "https://status.mc.ntzyz.cn/get.php?limit=" + limit,\n'
'    type: "GET",\n'
'    beforeSend: function() {\n'
'      $(\'#loadchart\').html(\'获取数据中\');\n'
'      $(\'#memchart\').html(\'获取数据中\');\n'
'    }\n'
'  }).done(function(data) {\n'
'    var res = JSON.parse(data);\n'
'    template.xAxis.categories = Array(limit).fill(0).map(function (it, off) {return limit - off;});\n'
'    template.title.text = \'Load Average\';\n'
'    template.series[0].name = \'Load\';\n'
'    template.series[0].data = Array(limit).fill(0).map(function (it, off) {return res.data[off].cpu_load * 1;}).reverse();\n'
'    $(\'#loadchart\').highcharts(template);\n'
'    template.title.text = \'Memory Used\';\n'
'    template.series[0].name = \'MB\';\n'
'    template.series[0].data = Array(limit).fill(0).map(function (it, off) {return res.data[off].mem_used * 1;}).reverse();\n'
'    $(\'#memchart\').highcharts(template);\n'
'  });\n'
'</code>\n'
'<p class="indent">这样，就完成了所有的数据采集、记录和显示工作了。在那段 PHP 脚本中可以看出，只要修改 limit 的值，就能获得不同数量的数据，因此短时间的数据显示和长时间的数据显示就都可以完成了。</p>\n'
'<h2>皮肤配置、上传与预览</h2>\n'
'<p class="indent">去年暑假剁了正版 Minecraft 之后才知道这个游戏是有皮肤这个设定的，然而在 Online Mode 设置为 Off 的服务器上，客户端并不会去从 Mojang 的服务器上获得其他玩家的皮肤数据，这样别人就看不到我的皮肤了（雾</p>\n'
'<h3>皮肤配置</h3>\n'
'<p class="indent">由于没有使用正版验证的玩家是不能通过官方途径更换自己的皮肤，我们需要使用额外的 Mod 来实现皮肤的自定义。这里我们使用了 <a href="https://github.com/RecursiveG/UniSkinMod">UniSkinMode</a>，<a href="https://github.com/RecursiveG/UniSkinServer/blob/master/doc/UniSkinAPI_zh-CN.md">配置的方法</a>也不算麻烦。</p>\n'
'<h3>皮肤上传</h3>\n'
'<p class="indent">按照 UniSkinMod 的 API，我们需要准备每个玩家的 JSON 信息，同时准备一个 textures 目录来存储 PNG 格式的皮肤。上传皮肤只需要修改对应的 JSON 文件，同时添加/更新 textures 目录下对应的文件即可。综上，这些工作只需要一段 PHP 就可以完成。</p>\n'
'<code><?php\n'
'  header("Access-Control-Allow-Origin: *");\n'
'  if (!isset($_GET[\'user\']))\n'
'    die(\'something wrong\');\n'
'\n'
'  $user = $_GET[\'user\'];\n'
'  $target_dir = "/var/www/skin/textures/";\n'
'  $target_file = $target_dir . $_GET[\'user\'];\n'
'  $imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);\n'
'\n'
'  if (!move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {\n'
'    if (!$_FILES["file"])\n'
'      die(\'file not set\');\n'
'    die(\'上传失败\');\n'
'  }\n'
'  else {\n'
'    $file = fopen("/var/www/skin/" . $user . ".json", "w");\n'
'    fwrite($file, "{\"player_name\": \"". $user ."\",  \"last_update\": 1416300800,  \"model_preference\": [\"default\"],  \"skins\": {    \"default\": \"". $user ."\"  }}");\n'
'    fclose($file);\n'
'    die(\'上传成功\');\n'
'  }\n'
'?></code>\n'
'<h3>皮肤预览</h3>\n'
'<p class="indent">做这个纯粹是我比较想折腾折腾，毕竟 WebGL 出来这么多年了，同时也有 Three.js 这种很好用的 JavaScript 3D 库。这里的工作相当繁杂（然而逻辑很简单，都特么 UV 贴图数据要手撕）。想了解的可以直接去看下<a href="https://skin.ssl.ntzyz.cn/skin_preview.js">源码</a>。</p>\n',
    160728, 2,
    '按照以往运行 Minecraft 服务器的情况，玩家们常常需要一些游戏以外的信息 [...]'
);

INSERT INTO post(post_title, post_content, post_date, post_category_id, post_shot, render_type) VALUES
(
    'Jade 渲染测试',
    'style.\n'
    '    h1.myclass { color: #080;}\n'
    '    p.indent {text-indent: 2em;}\n'
	'h1.myclass 标题1\n'
    'h2 标题2\n'
    'p.indent 正文\n'
    'code(lang="cpp").\n'
    '    #include <iostream>\n'
    '    \n'
    '    int main(void) {\n'
    '        std::cout << "Hello World" << std::endl;\n'
    '        return 0;\n'
    '    }\n'
    'p.indent Jade 讲道理还是蛮好用的，不过改名 pug 了就感觉不萌了呢（（\n',
    '160802',
    '5',
    '标题1 [...]',
    1
);

INSERT INTO post(post_title, post_content, post_date, post_category_id, post_shot, render_type) VALUES
(
    'MD 渲染测试',
    '# 模拟POS\n'
    '\n'
    '某自选商店需要定购一种POS终端，这个终端使用LED向顾客显示应付金额，已收金额和找零金额。顾客购买商品后，由收银员统计应付金额，并通过你的程序向顾客显示应付款。顾客给足付款后，收银员计算出找零并同时通过你的程序显示已收金额和找零金额。当然顾客也可能因为最后应付金额过大而取消购买，这样就在屏幕上显示CANCEL字样。由于商店规模不是很大，假定顾客购买的所有商品均在999元以内。因此实际一次显示金额最宽不超过7个字符(￥XXX.XX)。\n'
    '\n'
    '你的程序需要实现以下功能：\n'
    '\n'
    '1. POS开机：第一次使用POS机，需要事先清除当日已收款\n'
    '2. 统计应付金额：收银员输入应付金额，在屏幕上用7×8点阵显示应付金额\n'
    '3. 收款找零：收银员输入顾客付款，在屏幕上分两行显示已收款和找零款\n'
    '4. 取消付款：收银员取消本次购买。\n'
    '5. 日结算：收银员统计当日销售额。\n'
    '\n'
    '```\n'
    '@Override\n'
    'protected void onCreate(Bundle savedInstanceState) {\n'
    '    super.onCreate(savedInstanceState);\n'
    '    setContentView(R.layout.activity_main);\n'
    '\n'
    '    DBox.init(this, "Test.db");\n'
    '}\n'
    '```\n',
    '160802',
    '5',
    '模拟POS [..]',
    2
);