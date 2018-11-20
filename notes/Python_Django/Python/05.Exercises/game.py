# BASEBALL GAME!
# Needs : Three NUMBERS validation
import random

def get_guess():
    guess = input("What is your guess?")
    if type(guess) == int :
        guess = str(guess)
    return list(guess)

def generate_code():
    digits = [str(num) for num in range(10)]
    random.shuffle(digits)
    return digits[:3]

def generate_clues(userGuess, code):
    if guess == code :
        return["Three Strikes!"]

    clues = []
    for index, number in enumerate(userGuess):
        if number == code[index]:
            clues.append("Strike")
        elif number in code:
            clues.append("Ball")
    if clues == []:
        return ["Out"]
    else:
        return clues

print("Welcome to baseball game!")

clueReport = []
answer = generate_code()
print("The game is ready!")

while clueReport !=["Three Strikes!"]:
    guess = get_guess()

    clueReport = generate_clues(guess, answer)
    for clue in clueReport:
        print(clue)
