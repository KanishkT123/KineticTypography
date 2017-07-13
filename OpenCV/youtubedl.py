from pytube import YouTube

filename = "vids"
with open(filename, 'r') as f:
	for url in f:
		yt = YouTube(url)
		try:
			video = yt.get("mp4", "1080p")
		except:
			try:
				video = yt.get("mp4", "720p")
			except:
				try:
					video = yt.get("mp4", "480p")
				except e:
					print(e)
		video.download('./videos')