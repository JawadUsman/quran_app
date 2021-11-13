class AppPlayerState {
  bool isInitial;
  bool isBuffering;
  bool isPlaying;
  bool isPaused;
  bool isStopped;
  Duration? duration;
  Duration? totalDuration;

  AppPlayerState.initial(
      {this.isBuffering = false,
      this.isInitial = true,
      this.isPlaying = false,
      this.isPaused = false,
      this.isStopped = false,
        this.duration,this.totalDuration});

  AppPlayerState.buffering(
      {this.isBuffering = true,
      this.isInitial = true,
      this.isPlaying = false,
      this.isPaused = false,
      this.isStopped = false,
      this.duration,
      this.totalDuration});

  AppPlayerState.playing(
      {this.isBuffering = false,
      this.isInitial = false,
      this.isPlaying = true,
      this.isPaused = false,
      this.isStopped = false,
       this.duration,
       this.totalDuration});

  AppPlayerState.paused(
      {this.isBuffering = false,
      this.isInitial = false,
      this.isPlaying = false,
      this.isPaused = true,
      this.isStopped = false,
       this.duration,
       this.totalDuration});

  AppPlayerState.stopped(
      {this.isBuffering = false,
      this.isInitial = false,
      this.isPlaying = false,
      this.isPaused = false,
      this.isStopped = true,
       this.duration,
       this.totalDuration});
}
