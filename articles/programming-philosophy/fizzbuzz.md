# Kanso FizzBuzz

We all know the classic "FizzBuzz" interview question, reproduced here for reference:

> Write a program that prints the numbers from 1 to 100.
> But for multiples of three print "Fizz" instead of the number, and for the multiples of five print "Buzz".
> For numbers which are multiples of both three and five print "FizzBuzz".

Without further ado, here's my FizzBuzz[^catering]:

[^catering]: It's in Haskell, and I'm not bothering to cater to your ignorance of the language.

```
main :: IO ()
main =  print `mapM_` fizzbuzz [1..100]

fizzbuzz :: (Integral a, Show a) => [a] -> [String]
fizzbuzz = (loop <$>)
    where
    loop n = case (n `mod` 3 == 0, n `mod` 5 == 0) of
        (False, False) -> show n
        (True,  False) -> "Fizz"
        (False, True)  -> "Buzz"
        (True,  True)  -> "FizzBuzz"
```

Notice (1) I've made exactly zero effort to generalize my solution, (2) I'm using magic strings, (3) there's duplication between those magic strings, and (4) I'm using the `a % b == 0` idiom.
There are good reasons for these choices, even if you think they're failings.

#1. Let's play a game: you give me a generalized FizzBuzz program, and I'll try to give a different generalization of the problem that you can't solve without changing your code; I'll win every time.
FizzBuzz is a problem so disconnected from reality---i.e. useless---that there's not the meagerest indication of what new "features" your "users" will "want".
With only my ability to speculate, it would be an epistemic miracle if I chose the correct generalization, so I'm not going to waste my time guessing.

#^s^2&3. What are you going to do to eliminate or condense these strings?
Perhaps `let fizz = "Fizz"`?
If so, don't forget to `let one = 1` too.
Or just don't be stupid: note that (1) the magic strings are localized to a single, small function, and (2) the problem statement is perfectly clear, even though it uses strings in exactly the same form as the code.
Unless it will deliver added clarity or reliability, I'm not going to write unnecessary code.

#4. Until some sort of `isDivisibleBy` function makes it into standard libraries, I'm content to use the centuries-old definition of divisibility in my code.
Make no mistake: I have made improved standard libraries before, but it's just too hard to stick to that custom stuff everywhere, no matter how quality it is.
A less ambitious solution is to give this idiom a definition in its own library, but that induces a left-pad kind of problem.
I'm not going to re-define this idiom every time I want to use it.

## Conclusion

A simple problem requires a simple solution.
On its own, FizzBuzz as an interview question only filters out those that can't write code at all.
If you want to test applicants' abilities more in-depth, ask deeper questions.
Ask them to modify a program, characterize the possible results of a function given the range of possible inputs, or decompose a large problem into smaller units.
