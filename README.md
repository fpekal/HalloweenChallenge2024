# The LaurieWired 2024 Halloween Programming Challenge 🎃

Nyahaha! I have the ultimate solution to stop those pesky bots! *wobbles cutely* Instead of regular CAPTCHA, let’s make it a… *drumroll* Wordle CAPTCHA! *pumps fists in the air* Yes!

So, you know how Wordle is all about guessing the right word in a limited number of tries? Mine doesn't even work like that! *makes silly noises*

*leans in conspiratorially* Imagine the joy! Real users will be laughing while the bots are left scratching their… uh, virtual heads! *twirls around twisting her arms in all directions*

So, let’s make the internet a little more fun and a little less bot-y! *does a little dance* How about it? Let’s save the world one Wordle at a time! *throws confetti*

---

## How to run it
You will need **the best** package manager - *Nix*.
That's because this captcha is actually a linux package (should work on WSL2 as well).

Then just run
```sh
nix-build --arg captcha \"\"
```

Captcha should be entered like this
```sh
nix-build --arg captcha \"foo\"
```

Every time you run it, there will be a new `result` file containing
built output.


If you didn't succeed in 30s then skill issue.
