/****** Object:  ForeignKey [FK_comment_post]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_comment_post]') AND parent_object_id = OBJECT_ID(N'[dbo].[comment]'))
ALTER TABLE [dbo].[comment] DROP CONSTRAINT [FK_comment_post]
GO
/****** Object:  ForeignKey [FK_post_post]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_post_post]') AND parent_object_id = OBJECT_ID(N'[dbo].[post]'))
ALTER TABLE [dbo].[post] DROP CONSTRAINT [FK_post_post]
GO
/****** Object:  ForeignKey [FK_tagToAuthor_author]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tagToAuthor_author]') AND parent_object_id = OBJECT_ID(N'[dbo].[tagToAuthor]'))
ALTER TABLE [dbo].[tagToAuthor] DROP CONSTRAINT [FK_tagToAuthor_author]
GO
/****** Object:  ForeignKey [FK_tagToAuthor_tag]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tagToAuthor_tag]') AND parent_object_id = OBJECT_ID(N'[dbo].[tagToAuthor]'))
ALTER TABLE [dbo].[tagToAuthor] DROP CONSTRAINT [FK_tagToAuthor_tag]
GO
/****** Object:  ForeignKey [FK_tagToPost_post]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tagToPost_post]') AND parent_object_id = OBJECT_ID(N'[dbo].[tagToPost]'))
ALTER TABLE [dbo].[tagToPost] DROP CONSTRAINT [FK_tagToPost_post]
GO
/****** Object:  ForeignKey [FK_tagToPost_tag]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tagToPost_tag]') AND parent_object_id = OBJECT_ID(N'[dbo].[tagToPost]'))
ALTER TABLE [dbo].[tagToPost] DROP CONSTRAINT [FK_tagToPost_tag]
GO
/****** Object:  Table [dbo].[tagToAuthor]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tagToAuthor]') AND type in (N'U'))
DROP TABLE [dbo].[tagToAuthor]
GO
/****** Object:  Table [dbo].[comment]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[comment]') AND type in (N'U'))
DROP TABLE [dbo].[comment]
GO
/****** Object:  Table [dbo].[tagToPost]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tagToPost]') AND type in (N'U'))
DROP TABLE [dbo].[tagToPost]
GO
/****** Object:  Table [dbo].[post]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[post]') AND type in (N'U'))
DROP TABLE [dbo].[post]
GO
/****** Object:  Table [dbo].[author]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[author]') AND type in (N'U'))
DROP TABLE [dbo].[author]
GO
/****** Object:  Table [dbo].[tag]    Script Date: 01/28/2010 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tag]') AND type in (N'U'))
DROP TABLE [dbo].[tag]
GO
/****** Object:  Role [apptacular_user]    Script Date: 01/28/2010 10:34:52 ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'apptacular_user')
BEGIN
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'apptacular_user' AND type = 'R')
CREATE ROLE [apptacular_user]

END
GO
/****** Object:  Table [dbo].[tag]    Script Date: 01/28/2010 10:34:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tag]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tag](
	[tagid] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[createdOn] [datetime] NULL,
	[updatedOn] [datetime] NULL,
 CONSTRAINT [PK_tag] PRIMARY KEY CLUSTERED 
(
	[tagid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
SET IDENTITY_INSERT [dbo].[tag] ON
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (1, N'ColdFusion', CAST(0x00009CD800D25D84 AS DateTime), CAST(0x00009CD800D25D84 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (2, N'Flex', CAST(0x00009CD800D26810 AS DateTime), CAST(0x00009CD800D26810 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (3, N'Flash Builder', CAST(0x00009CD800D273C8 AS DateTime), CAST(0x00009CD800D273C8 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (4, N'ColdFusion Builder', CAST(0x00009CD800D27E54 AS DateTime), CAST(0x00009CD800D27E54 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (5, N'Flash', CAST(0x00009CE000F6F324 AS DateTime), CAST(0x00009CE000F6F324 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (6, N'Java', CAST(0x00009CE000FCF378 AS DateTime), CAST(0x00009CE000FCF378 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (7, N'Higher Education', CAST(0x00009CE100BE7634 AS DateTime), CAST(0x00009CE100BE7634 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (8, N'MySQL', CAST(0x00009CE100BE8C78 AS DateTime), CAST(0x00009CE100BE8C78 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (9, N'Code Generation', CAST(0x00009CE100BE9A88 AS DateTime), CAST(0x00009CE100BE9A88 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (10, N'Apache Derby', CAST(0x00009CE100BEBEDC AS DateTime), CAST(0x00009CE100BEBEDC AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (11, N'Flash Catalyst', CAST(0x00009CE100BEFBCC AS DateTime), CAST(0x00009CE100BEFBCC AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (12, N'Evangelist', CAST(0x00009CE100BF3C40 AS DateTime), CAST(0x00009CE100BF3C40 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (13, N'AIR', CAST(0x00009CE100BF5D10 AS DateTime), CAST(0x00009CE100BF5D10 AS DateTime))
INSERT [dbo].[tag] ([tagid], [name], [createdOn], [updatedOn]) VALUES (14, N'AIR with JavaScript', CAST(0x00009CE100BF7480 AS DateTime), CAST(0x00009CE100BF7480 AS DateTime))
SET IDENTITY_INSERT [dbo].[tag] OFF
/****** Object:  Table [dbo].[author]    Script Date: 01/28/2010 10:34:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[author]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[author](
	[authorID] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[lastName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[email] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[createdOn] [datetime] NOT NULL,
	[updatedOn] [datetime] NOT NULL,
	[isEditor] [bit] NOT NULL,
	[dob] [datetime] NOT NULL,
 CONSTRAINT [PK_author] PRIMARY KEY CLUSTERED 
(
	[authorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
SET IDENTITY_INSERT [dbo].[author] ON
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (1, N'Terrence', N'Ryan ', N'terry@terrenceryan.com', CAST(0x00009CCC00C5C100 AS DateTime), CAST(0x00009CDF00B75340 AS DateTime), 1, CAST(0x00006DCF00000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (2, N'Earl', N'Ragefest', N'earl@ragefest', CAST(0x00009CCC00D97010 AS DateTime), CAST(0x00009CCC00D97010 AS DateTime), 0, CAST(0x00006DCF00000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (3, N'Adam', N'Lehman', N'adam@adrocknapohbia.com', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 0, CAST(0x0000707300000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (4, N'Ryan', N'Stewart', N'ryan@ryanstewart.com', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 0, CAST(0x0000722300000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (5, N'Kevin', N'Hoyt', N'kevin@kevinhoyt.com', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 1, CAST(0x00006B0100000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (6, N'Serge', N'Jespers', N'serge@webkitchen.be', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 1, CAST(0x00006B0100000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (7, N'Ben', N'Forta', N'ben@forta.com', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 1, CAST(0x000063DF00000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (8, N'Lee', N'Brimlowe', N'lee@brimlow.com', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 0, CAST(0x00006B0100000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (9, N'Ted', N'Patrick', N'ted@adobe.com', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 0, CAST(0x00006B0100000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (10, N'Andrew', N'Shorten', N'ashorten@adobe.com', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 0, CAST(0x00006B0100000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (11, N'Greg', N'Wilson', N'gwilson@adobe.com', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 1, CAST(0x000063DF00000000 AS DateTime))
INSERT [dbo].[author] ([authorID], [firstName], [lastName], [email], [createdOn], [updatedOn], [isEditor], [dob]) VALUES (12, N'Danny', N'Dura', N'ddura@adobe.com', CAST(0x00009CCC00CAC560 AS DateTime), CAST(0x00009CCC00CAC560 AS DateTime), 0, CAST(0x00006B0100000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[author] OFF
/****** Object:  Table [dbo].[post]    Script Date: 01/28/2010 10:34:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[post]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[post](
	[postID] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[body] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[createdOn] [datetime] NOT NULL,
	[updatedOn] [datetime] NOT NULL,
	[authorID] [int] NOT NULL,
 CONSTRAINT [PK_post] PRIMARY KEY CLUSTERED 
(
	[postID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
SET IDENTITY_INSERT [dbo].[post] ON
INSERT [dbo].[post] ([postID], [title], [body], [createdOn], [updatedOn], [authorID]) VALUES (1, N'ColdFusion Builder Rocks', N'<p>It''s awesome.&nbsp; It integrates with Flex Builder.&nbsp; I once saw it lift a burning car off it''s injured son.&nbsp; It''s asymptotically approaching infinity.</p>', CAST(0x00009CCC010E2184 AS DateTime), CAST(0x00009CDF00B6448C AS DateTime), 1)
INSERT [dbo].[post] ([postID], [title], [body], [createdOn], [updatedOn], [authorID]) VALUES (2, N'ColdFusion 9 is Awesome', N'<p>Yeah, I said it.&nbsp; So what. It is. </p>', CAST(0x00009CCC011ECFD4 AS DateTime), CAST(0x00009CD900AEB820 AS DateTime), 1)
INSERT [dbo].[post] ([postID], [title], [body], [createdOn], [updatedOn], [authorID]) VALUES (3, N'Flex 4 is going to be a game changer', N'<p>And that game will be &quot;Yahtzee.&quot;</p>', CAST(0x00009CD8013CD178 AS DateTime), CAST(0x00009CD900AEEE08 AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[post] OFF
/****** Object:  Table [dbo].[tagToPost]    Script Date: 01/28/2010 10:34:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tagToPost]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tagToPost](
	[tagID] [int] NOT NULL,
	[postID] [int] NOT NULL
)
END
GO
INSERT [dbo].[tagToPost] ([tagID], [postID]) VALUES (1, 2)
INSERT [dbo].[tagToPost] ([tagID], [postID]) VALUES (2, 3)
INSERT [dbo].[tagToPost] ([tagID], [postID]) VALUES (3, 1)
INSERT [dbo].[tagToPost] ([tagID], [postID]) VALUES (3, 3)
INSERT [dbo].[tagToPost] ([tagID], [postID]) VALUES (4, 1)
INSERT [dbo].[tagToPost] ([tagID], [postID]) VALUES (4, 3)
/****** Object:  Table [dbo].[comment]    Script Date: 01/28/2010 10:34:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[comment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[comment](
	[commentID] [int] IDENTITY(1,1) NOT NULL,
	[postID] [int] NOT NULL,
	[body] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[email] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[website] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[createdOn] [datetime] NOT NULL,
	[updatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_comment] PRIMARY KEY CLUSTERED 
(
	[commentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
SET IDENTITY_INSERT [dbo].[comment] ON
INSERT [dbo].[comment] ([commentID], [postID], [body], [name], [email], [website], [createdOn], [updatedOn]) VALUES (1, 1, N'<p>ROOOOOOOAAAARRRRRR!</p>', N'Earl', N'earl@ragefest.com', N'http://www.earl.com', CAST(0x00009CCC00C5C100 AS DateTime), CAST(0x00009CD900AF4F4C AS DateTime))
INSERT [dbo].[comment] ([commentID], [postID], [body], [name], [email], [website], [createdOn], [updatedOn]) VALUES (2, 2, N'<p>I agree, but I am you, so I better.</p>', N'Terrence P Ryan', N'terrence.p.ryan@gmail.com', N'http://terrenceryan.com', CAST(0x00009CCC016A0490 AS DateTime), CAST(0x00009CD900AF3908 AS DateTime))
INSERT [dbo].[comment] ([commentID], [postID], [body], [name], [email], [website], [createdOn], [updatedOn]) VALUES (3, 3, N'<p>I''d rather it be Flaming Labala. </p>', N'Terrence Ryan', N'terry@numtopia.com', N'http://terrenceryan.com', CAST(0x00009CD8013D0F94 AS DateTime), CAST(0x00009CD900AF251C AS DateTime))
INSERT [dbo].[comment] ([commentID], [postID], [body], [name], [email], [website], [createdOn], [updatedOn]) VALUES (4, 1, N'<p>I totally and whole heartedly agree</p>', N'Terrence P Ryan', N'terrence.p.ryan@gmail.com', N'http://terrenceryan.com', CAST(0x00009CDA00945A20 AS DateTime), CAST(0x00009CDA00945A20 AS DateTime))
SET IDENTITY_INSERT [dbo].[comment] OFF
/****** Object:  Table [dbo].[tagToAuthor]    Script Date: 01/28/2010 10:34:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tagToAuthor]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tagToAuthor](
	[tagID] [int] NULL,
	[authorID] [int] NOT NULL
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tagToAuthor]') AND name = N'IX_tagToAuthor')
CREATE NONCLUSTERED INDEX [IX_tagToAuthor] ON [dbo].[tagToAuthor] 
(
	[tagID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
GO
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (1, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (2, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (3, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (4, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (7, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (8, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (9, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (10, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (11, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (14, 1)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 2)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 2)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (1, 3)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (4, 3)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 3)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 3)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (11, 4)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 4)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 4)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (11, 5)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 5)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 5)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (14, 5)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (11, 6)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 6)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 6)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 7)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 7)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 8)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 8)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 9)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 9)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (11, 10)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 10)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 10)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 11)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 11)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (12, 12)
INSERT [dbo].[tagToAuthor] ([tagID], [authorID]) VALUES (13, 12)
/****** Object:  ForeignKey [FK_comment_post]    Script Date: 01/28/2010 10:34:52 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_comment_post]') AND parent_object_id = OBJECT_ID(N'[dbo].[comment]'))
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_post] FOREIGN KEY([postID])
REFERENCES [dbo].[post] ([postID])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_post]
GO
/****** Object:  ForeignKey [FK_post_post]    Script Date: 01/28/2010 10:34:52 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_post_post]') AND parent_object_id = OBJECT_ID(N'[dbo].[post]'))
ALTER TABLE [dbo].[post]  WITH CHECK ADD  CONSTRAINT [FK_post_post] FOREIGN KEY([authorID])
REFERENCES [dbo].[author] ([authorID])
GO
ALTER TABLE [dbo].[post] CHECK CONSTRAINT [FK_post_post]
GO
/****** Object:  ForeignKey [FK_tagToAuthor_author]    Script Date: 01/28/2010 10:34:52 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tagToAuthor_author]') AND parent_object_id = OBJECT_ID(N'[dbo].[tagToAuthor]'))
ALTER TABLE [dbo].[tagToAuthor]  WITH CHECK ADD  CONSTRAINT [FK_tagToAuthor_author] FOREIGN KEY([authorID])
REFERENCES [dbo].[author] ([authorID])
GO
ALTER TABLE [dbo].[tagToAuthor] CHECK CONSTRAINT [FK_tagToAuthor_author]
GO
/****** Object:  ForeignKey [FK_tagToAuthor_tag]    Script Date: 01/28/2010 10:34:52 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tagToAuthor_tag]') AND parent_object_id = OBJECT_ID(N'[dbo].[tagToAuthor]'))
ALTER TABLE [dbo].[tagToAuthor]  WITH CHECK ADD  CONSTRAINT [FK_tagToAuthor_tag] FOREIGN KEY([tagID])
REFERENCES [dbo].[tag] ([tagid])
GO
ALTER TABLE [dbo].[tagToAuthor] CHECK CONSTRAINT [FK_tagToAuthor_tag]
GO
/****** Object:  ForeignKey [FK_tagToPost_post]    Script Date: 01/28/2010 10:34:52 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tagToPost_post]') AND parent_object_id = OBJECT_ID(N'[dbo].[tagToPost]'))
ALTER TABLE [dbo].[tagToPost]  WITH CHECK ADD  CONSTRAINT [FK_tagToPost_post] FOREIGN KEY([postID])
REFERENCES [dbo].[post] ([postID])
GO
ALTER TABLE [dbo].[tagToPost] CHECK CONSTRAINT [FK_tagToPost_post]
GO
/****** Object:  ForeignKey [FK_tagToPost_tag]    Script Date: 01/28/2010 10:34:52 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tagToPost_tag]') AND parent_object_id = OBJECT_ID(N'[dbo].[tagToPost]'))
ALTER TABLE [dbo].[tagToPost]  WITH CHECK ADD  CONSTRAINT [FK_tagToPost_tag] FOREIGN KEY([tagID])
REFERENCES [dbo].[tag] ([tagid])
GO
ALTER TABLE [dbo].[tagToPost] CHECK CONSTRAINT [FK_tagToPost_tag]
GO
