---
title: 8. 自我监督
author: 李笑来
date: 2024-12-02 11:17:08 +0800
categories: [self-training from lixiaolai]
tags: [Self-training]
pin: false
math: true
mermaid: true
---

# 8. 自我监督

保证工作成效的一个重要关键在于，到最后总得有个**验收**。复杂的任务可以被拆分成可处理的小任务，而每个小任务都可以有它自己的验收环节 —— 为了这个不可或缺的环节真正发挥作用，还得为它配上足够系统完善的**验收标准**。而所谓的**验收标准**，说穿了倒也非常简单，只不过是**分得清好坏**。

孙犁先生写过一篇文章探讨**好的语言**和**坏的语言**：

> 根据我们的最有功绩的文学老师的说法，有如下性质的语言是文学上的好的语言：
>
> > 1. 明确；
> > 2. 朴素；
> > 3. 简洁；
> > 4. 浮雕；
> > 5. 音乐性；
> > 6. 和现实生活有紧密联系。
>
> 相反的，这些语言是坏的语言：
>
> > 1. 干燥无味；
> > 2. 没有个性；
> > 3. 不正确的方言；
> > 4. 胡乱的表现；
> > 5. 似是而非的丰富；
> > 6. 不和现实生活呼应。

这就是孙犁先生自己总结自己遵守的**验收标准**，用来衡量自己的文字是否满意。这种系统完善的验收标准，不一定只在最后起作用，深信并熟练到一定程度，它就会时时刻刻起作用。任何时候发现自己正在写的是坏的语言，就一定会挣扎着改掉，想尽一切办法创造好的语言。

在我们的语音塑造训练中，每个音素都可能有不止一条验收标准，比如，<span class="pho">t</span> 这个**音素**的发音就有很多验收标准：

> * 发声时舌尖的起始位置对不对？（[3.2.2.2](/sounds-of-american-english/3.2.2-td#_3-2-2-2-舌尖起始位置)）
> * 它是不是产生了塞音？（[3.2.2.3.2](/sounds-of-american-english/3.2.2-td#_3-2-2-3-2-阻塞音-t)）
> * 它是不是应该被读成浊化音 <span class="pho alt">d</span>？（[3.2.2.3.5](/sounds-of-american-english/3.2.2-td#_3-2-2-3-5-t-的浊化t)）
> * 它是不是应该被读成 <span class="pho alt">tʃ</span>？（[4.4.2.3](/sounds-of-american-english/4.4-linking#_4-4-2-3-同化-assimilation)）
> * 它是不是应该被读成弹舌音 <span class="pho alt">t̬</span>？（[3.2.2.3.1](/sounds-of-american-english/4.4-linking#3.2.2-td#_3-2-2-3-1-弹舌音-t)）
> * 它是不是应该被读成喉塞音 <span class="pho alt">ʔ</span>？（[3.2.2.3.4](/sounds-of-american-english/3.2.2-td#_3-2-2-3-4-喉塞音-ʔ)）

对整个自然语句，除了每个**音素**都有自己的验收标准之外，还有**韵律**和**节奏**上的判断标准：

> * 停顿：每个停顿是否处理得当？有没有分别做对做好？（[4.2](/sounds-of-american-english/4.3-grouping)）
> * 高低：哪些音节音高被拔高了？有没有分别做对做好？（[4.5.4](/sounds-of-american-english/4.5-sentences#_4-5-4-音高变化)）
> * 起伏：哪些音节带着明显的声调？分别是什么？有没有分别做对做好？（[4.5.5](/sounds-of-american-english/4.5-sentences#_4-5-5-声调变化)）
> * 轻重：哪些词被弱读了？被弱读成了什么样子？有没有分别做对做好？（[4.5.1](/sounds-of-american-english/4.5-sentences#_4-5-1-弱读词汇)）
> * 缓急：哪些词连在一起读得很快？被读成了什么样子？有没有分别做对做好？（[4.5.6](/sounds-of-american-english/4.5-sentences#_4-5-6-语速)）

无论学什么，都一样的，每个重点知识的理解和应用都有相应的**验收标准**。从这个角度望过去，无论是校内的数学、物理、化学，还是地理、生物，抑或历史、文学，课本的核心都一样，都是一个又一个的验收标准…… 校外的计算机编程语言的教材里还是如此 —— 天下所有教材都是如此。

我们要擅长的，就是把那些验收标准谙熟于心，不仅在做的时候就可以用它自我纠正，在完成的时候也同样可以用它完成最后验收。

自学或者自我训练最重要的一个技巧就是先完成**角色转换**：

> **像老师一样学习**……

换个说法也行：“**教是最好的学习方法**”。不能靠别人教，那就自己教自己，不能靠别人监督，那就自己监督自己。

这种角色转换之所以效果惊人，根源在于它在不知不觉中**提高**了**验收标准**。若是一位学生按照老师的标准要求自己，那么水平就会被拔高；若是一位老师竟然按照学生的标准要求自己，那么水平就会很差，并且还总是停滞不前。

其实这是我们经常做的事情 —— 比如，像作者一样读书，像导演一样看电影，或者像专家一样做事…… 试过一段时间就知道了，只要标准被抬高，效果和质量就会自然随之发生变化。

最有趣的是，很多时候，标准的抬高，并不总是意味着难度也随之必然被抬高。反正做事要花时间，标准高不高都得花时间，90% 以上的时间成本和注意力成本都无法进一步压缩。在学习的时候尤其如此，当下的标准抬高，也许提高了一些难度，的确也增加了一些时间和注意力的成本，但，由于做的正确，做得更好，会极大降低将来整体的时间和注意力成本 —— 从这个角度望过去，抬高标准不仅没有提高难度，反倒是事实上降低了难度。

很多人不是为了自己学习，不是为了自己做事，是为了糊弄家长、老师或者老板，所以没有动力精益求精，所以喜欢反过来偷懒…… 可问题在于，这样做永远不划算，因为花掉的是自己的时间，自己的注意力，却并没有长出自己的本事，亏大了 —— 当然，习惯了，亏麻了之后，倒也感觉并无所谓。

我们有天然的**归纳总结能力**。随着时间的推移，我们会把大量的相关要素分门别类，抽象成更为精简的概括，并且总是按照**重要性排序**…… 在更容易记忆更容易调用的同时，无论是在做事的过程中，还是事后的验收里，带着这样的标准工作，总是显得更加游刃有余。孙犁先生对语言好坏的标准看起来很少，就那么几条，但，那是**长期积累**之后的抽象和概括。

我个人对我自己的文字好坏，经过长期概括之后，验收标准仅剩下一句话：“**是否对读者真的长期有用？**” 如果不是，就扔掉，或者干脆不写了。这并不是说我没有更多细节上的标准了，而是那些已经应用过无数回了，乃至于下意识之中就已经处理完毕。当然，最重要的总是要三思而行。

其实，**验收标准大多是通用的**，虽然偶尔也有例外。在这里是好的，在别的地方大抵上也应该是好的，在这里是坏的，在别的地方大地上也应该是坏的。比如，简洁、朴素、直接、有效，几乎在任何地方任何领域，都可以被认为是好的。无论是小说还是论文，这样的文字就是我更欣赏的。无论是个人服饰还是室内装修，这样的风格也是我更喜欢的。沟通交流也好管理团队也罢，这还是我更倾向于选择的方式。

很多时候，这看起来是没有对错不分好坏的**个人偏好**，可实际上并不像很多人以为地那么**主观**，**好坏**常常可以非常**客观**。因为对任何人来说都一样，对好坏的分辨其实是长期有效经验的积累 —— 长期保持客观的人，他们的个人偏好都更倾向于客观。反过来，长期放任主观想法的人，他们的个人偏好客观来讲的确非常差 —— 虽然他们自己可以天真地以为或者争辩说，“个人偏好没有好坏对错”…… 姑且就让他们继续那么以为下去好了。

人最重要的能力就是**判断力**。简单讲，所谓判断力就是**分清好坏**的能力。判断力背后就是一个又一个**针对性**极强**客观性**极高的判断标准。没有判断，就没有质量，也没有选择，更没有智慧。所谓的**智慧**，本质上来看就是良好判断力的应用结果。人们平日里所说的**审美能力**，本质上来看还是**判断力**，分得清好坏。到最后，连**创造力**都是以判断力基础，由判断力引发的 —— 知道什么是陈词滥调（坏的），什么是新鲜创意（好的），所以才有不同的选择。

之前我们说人工智能帮我们解决了**眼高手低**的尴尬（[3.6](/training-tasks/revolution#_3-6-类比)），让我们的**实际操作能力**有机会追上我们的**审美能力** —— 想想看吧，这是不是天大的解脱？

人工智能越强，驾驭它的人必需更有判断力。在自然语言应用方面，能用人工智能辅助创作出更多更好文字的是那些具备更好判断力的人，与此同时，他们自己的语言文字能力在不断提升 —— 我们的训练就是这样的例子。

在图像生成方面，能用人工智能做出更多更好图片的，还是那些具有更好判断力的人 —— 或者说，更高审美能力也行 —— 他们知道各式各样的风格，所以可以在其中选择，他们知道各式各样的重点，可以系统地判断好坏，所以才能将咒语（*prompt*[^*]）写的清晰具体有效，于是人工智能才那么听话。

2023年年初，人工智能开始可以将人类提供的咒语转换成长达 1 分钟的视频。请问，这对谁最有用？在视频制作方面具备极高审美能力（判断力）的人。很多人在只能惊呼的同时，在付费学习如何如何编写咒语…… 这就好像是用千年祖传配方治疗糖尿病一样，令人笑不出来。

其实，真正应该系统学的练的是影视制作那一整套，编剧、导演、摄影、表演…… 在这个繁杂且有系统的知识网络里像探索迷宫一样游走，把每个重点的验收标准谙熟于心，逐步积累，归纳总结，抽象概括…… 最后形成一套属于自己的，同时也足够客观的**验收标准** —— 称作**审美能力**也罢，**判断力**也好，都一样。在此基础上，才有有真正的**创意**。只不过，这一次不同了，因为眼高手低的尴尬被人工智能解决了，于是，到最后，**人工智能是那些拥有更高审美能力的人手中真正的工具**。

所谓的监督，尤其是自我监督，不是人们误以为的 “头悬梁锥刺股” —— 真正的学习和训练，并不靠所谓的 “吃苦”。最好的自我监督，是**不断抬高对自己的要求**，即，**不断调整各种验收标准**，即，不断提高自己的判断力。

不断提高自己的判断力，有没有较为有效的方法呢？有，并且只有一个 —— **见多识广**。大量的输入，大量的积累，大量地吸收大量地消化，除此之外别无他法。其实，道理总是相通的。人工智能越来越聪明，发展越来越快的原因不也是同样的方式吗？人工智能可以如此，就是因为它在模拟人类的大脑。计算机是对大脑硬件上的模拟，人工智能就是对大脑软件上的模拟 —— 人工智能是人类迄今为止制作出来的最佳仿生产品。

见多识广靠不断的**追求**。长期持续追求的**动力**又来自何处呢？每个人可能相当不一样。在读高中的时候，我有个同桌经常说这么一句话: “咱是谁啊？！”

这句话的意思是:

> * “咱是谁啊？！” — 所以，“那些事儿不能干啊！”
> * “咱是谁啊？！” — 所以，“这种东西拿不出手啊！”
> * “咱是谁啊？！” — 所以，“做成这德性怎么好意思呢？”
> * “咱是谁啊？！” — 所以，“这事儿得做到这样的地步才行！”
> * ......

这句话一不小心影响了我的一生。因为它几乎总是最强的动力之一。

[^*]: “**咒语**” 是和菜头对 *prompt* 这个词的精彩翻译。