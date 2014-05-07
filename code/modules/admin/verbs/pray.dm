/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	if (usr.muted)
		return

	for (var/mob/M in world)
		if (M.client && M.client.holder)
			M << "\blue <b><font colour=purple>PRAY: </font>[key_name(src, M)](<A HREF='?src=\ref[M.client.holder];adminplayeropts=\ref[src]'>X</A>):</b> [msg]"

	usr << "Your prayers have been received by the gods."
	//log_admin("HELP: [key_name(src)]: [msg]")
