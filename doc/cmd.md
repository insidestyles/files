
- list size dpkg: dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n

- top 10 heavy files: find / -mount -type f -ls 2> /dev/null | sort -rnk7 | head -10 | awk '{printf "%10d MB\t%s\n",($7/1024)/1024,$NF}'
