#!/usr/bin/perl

# <bitbar.title>A simple 25 minute pomodoro timer</bitbar.title>
# <bitbar.version>v 1.0</bitbar.version>
# <bitbar.author>Deepak Gulati</bitbar.author>
# <bitbar.author.github>deepakg</bitbar.author.github>
# <bitbar.desc>Let's you start a 25 minute timer and notifies you when the time is up</bitbar.desc>
# <bitbar.image>https://github.com/deepakg/bitbar-pomodoro/raw/master/img/pomodoro-bitbar.png</bitbar.image>
# <bitbar.dependencies>perl</bitbar.dependencies>
# <bitbar.abouturl>http://url-to-about.com/</bitbar.abouturl>

use strict;
use warnings;

use 5.14.1;

my $threshold = 25; #timer in minutes
my $timer_file = '/tmp/com.deepakg.pomodoro.timer';
my $notification_file = '/tmp/com.deepakg.pomodoro.timer.notification';

my $menu_text = 'Start timer';

if (-f $timer_file) {
    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
     $atime,$mtime,$ctime,$blksize,$blocks)
        = stat($timer_file);

    my $current_time = time;
    my $elapsed = $current_time - $mtime;
    my $hh = $elapsed / 60 * 60;
    my $mm = $elapsed / 60;
    my $ss = $elapsed % 60;
    my $color = "";

    if ($mm >= $threshold) {
        if (! -f $notification_file) { #time up but no notification has been shown yet
            `osascript -e 'display notification "Your $threshold minutes are up!" with title "Time up" sound name "Purr"'`;
            open my $fh, '>', $notification_file;
            close $fh;
            $color = " | color=red";
            $mm = $threshold;
            $ss = 00;
            say sprintf("%02d:%02d", $mm, $ss), $color;
        }
        else {
            say '⏲'; #time up and notification shown - rever to icon instead of showing time elapsed
        }
    }
    else {
        if (-f $notification_file) {
            unlink $notification_file;
        }
        say sprintf("%02d:%02d", $mm, $ss), $color;
        $menu_text = "Reset timer";
    }
    
}
else {
    say '⏲'; #first run ever, simply show the timer emoji 
}
say "---";
say $menu_text . " | refresh=true terminal=false bash=/usr/bin/touch param1=$timer_file";

__END__
