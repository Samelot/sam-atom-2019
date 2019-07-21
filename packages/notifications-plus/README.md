# Notifications+ package
[![Build Status](https://travis-ci.org/UziTech/notifications.svg?branch=master)](https://travis-ci.org/UziTech/notifications)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/q7pdov4qeu2weee4?svg=true)](https://ci.appveyor.com/project/UziTech/notifications)
[![Dependency Status](https://david-dm.org/UziTech/notifications.svg)](https://david-dm.org/UziTech/notifications)

![notifications](https://cloud.githubusercontent.com/assets/69169/5176406/350d0e80-73fd-11e4-8101-1776b9d6d8bf.gif)

This is a fork of the core [notifications](https://github.com/atom/notifications) package that adds a few new features.

## Notifications Log

A log so you can check old notifications.

![notifications log](https://cloud.githubusercontent.com/assets/378023/20507678/85460af6-b09f-11e6-93df-9a82df59a383.png)

You can even click the buttons from the notifications log.

![log buttons](https://user-images.githubusercontent.com/97994/28998230-7d8fb300-79eb-11e7-8a19-22efb08972a7.JPG)

## Make notifications dismissable

Prevent a notification from auto closing by clicking on the notification or hover over the notification when it would close.

## Status bar notification count

See how many notifications are in the log.

![notifications-count](https://user-images.githubusercontent.com/97994/28998231-813edfbc-79eb-11e7-8bc9-8d97153f4243.gif)

## Disable popup notifications setting

Disable popup notifications when you don't want to be disturbed.

## Default auto close timeout setting

Set the amount of time you want the auto close notifications to stay open.

## Timeout option for notifications

Set the `timeout` option when adding a notification to override the default timeout.

### Docs

Notifications are available for use in your Atom packages via the `atom.notifications` `NotificationManager` object. See
https://atom.io/docs/api/latest/NotificationManager and https://atom.io/docs/api/latest/Notification for documentation.
