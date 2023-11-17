#!/bin/sh
rsync -azP --delete ./public/ spider@vmisery:/var/www/toggle.irgendwiesowas.com/public
