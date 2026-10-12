import os
import random
from datetime import datetime

class game:
    def board_size(self):
        while True:
            try:
                size = int(input('введите размер игрового поля (минимум 3): '))
                if size >= 3:
                    return size
                else:
                    print('размер должен быть не меньше 3!')
            except ValueError:
                print('пожалуйста, введите число!')

    def __init__(self):
        self.stats_dir = 'game_stats'
        self.stats_file = os.path.join(self.stats_dir, 'statistics.txt')
        if not os.path.exists(self.stats_dir):
            os.makedirs(self.stats_dir)
    
    def save_game_result(self, result, size, mode, first_player):
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        with open(self.stats_file, 'a', encoding='utf-8') as f:
            f.write(f'{timestamp} | поле: {size}x{size} | режим: {mode} | первый: {first_player} | результат: {result}\n')
    
    def print_board(self, board):
        size = len(board)
        print('\n   ' + ' '.join(str(i) for i in range(size)))
        
        for i in range(size):
            row_display = [str(i)]
            for j in range(size):
                cell = board[i][j] if board[i][j] else ' '
                row_display.append(cell)
            
            print('  ' + ' | '.join(row_display))
            
            if i < size - 1:
                print('   ' + '-' * (size * 4 - 1))
        print()
    
    def create_board(self, size):
        return [['' for _ in range(size)] for _ in range(size)]
    
    def check_winner(self, board):
        size = len(board)
        
        for row in range(size):
            first_cell = board[row][0]
            if first_cell:
                row_win = True
                for col in range(1, size):
                    if board[row][col] != first_cell:
                        row_win = False
                        break
                if row_win:
                    return first_cell
        
        for col in range(size):
            first_cell = board[0][col]
            if first_cell:
                col_win = True
                for row in range(1, size):
                    if board[row][col] != first_cell:
                        col_win = False
                        break
                if col_win:
                    return first_cell
        
        first_cell = board[0][0]
        if first_cell:
            diag1_win = True
            for i in range(1, size):
                if board[i][i] != first_cell:
                    diag1_win = False
                    break
            if diag1_win:
                return first_cell
        
        first_cell = board[0][size-1]
        if first_cell:
            diag2_win = True
            for i in range(1, size):
                if board[i][size-1-i] != first_cell:
                    diag2_win = False
                    break
            if diag2_win:
                return first_cell
        
        return None
    
    def is_board_full(self, board):
        for row in board:
            for cell in row:
                if not cell:
                    return False
        return True
    
    def player_move(self, board, player):
        size = len(board)
        
        while True:
            try:
                move = input(f'игрок {player}, введите строку и столбец (например: 0 1): ')
                parts = move.split()
                
                if len(parts) != 2:
                    print('нужно ввести два числа через пробел!')
                    continue
                
                row = int(parts[0])
                col = int(parts[1])
                
                if row < 0 or row >= size or col < 0 or col >= size:
                    print(f'координаты должны быть от 0 до {size-1}!')
                    continue
                
                if board[row][col]:
                    print('эта клетка уже занята!')
                    continue
                
                return row, col
                
            except ValueError:
                print('пожалуйста, введите числа!')
            except Exception as e:
                print(f'ошибка: {e}')
    
    def bot_move(self, board, bot_symbol):
        size = len(board)
        player_symbol = 'x' if bot_symbol == 'o' else 'o'
        
        for i in range(size):
            for j in range(size):
                if not board[i][j]:
                    board[i][j] = bot_symbol
                    if self.check_winner(board) == bot_symbol:
                        board[i][j] = ''
                        return i, j
                    board[i][j] = ''
        
        for i in range(size):
            for j in range(size):
                if not board[i][j]:
                    board[i][j] = player_symbol
                    if self.check_winner(board) == player_symbol:
                        board[i][j] = ''
                        return i, j
                    board[i][j] = ''
        
        center = size // 2
        if size % 2 == 1 and not board[center][center]:
            return center, center
        
        corners = [(0, 0), (0, size-1), (size-1, 0), (size-1, size-1)]
        random.shuffle(corners)
        for i, j in corners:
            if not board[i][j]:
                return i, j
        
        empty_cells = []
        for i in range(size):
            for j in range(size):
                if not board[i][j]:
                    empty_cells.append((i, j))
        
        return random.choice(empty_cells)
    
    def game_mode(self):
        while True:
            print('\nвыберите режим игры:')
            print('1 - игра с другом')
            print('2 - игра с ботом')
            choice = input('ваш выбор (1 или 2): ')
            
            if choice == '1':
                return 'pvp'
            elif choice == '2':
                return 'pve'
            else:
                print('пожалуйста, введите 1 или 2!')
    
    def first_player(self):
        return random.choice(['x', 'o'])
    
    def play_game(self):
        while True:
            game_mode = self.game_mode()
            size = self.board_size()
            first_player = self.first_player()
            
            print(f'\nпервым ходит: {first_player}')
            
            board = self.create_board(size)
            current_player = first_player
            game_finished = False
            
            while not game_finished:
                self.print_board(board)
                
                if game_mode == 'pvp' or current_player == 'x':
                    row, col = self.player_move(board, current_player)
                else:
                    print('ход бота...')
                    row, col = self.bot_move(board, current_player)
                    print(f'бот поставил {current_player} на ({row}, {col})')
                
                board[row][col] = current_player
                
                winner = self.check_winner(board)
                if winner:
                    self.print_board(board)
                    result = f'победил {winner}'
                    print(f'\n🎉 {result}!')
                    self.save_game_result(result, size, game_mode, first_player)
                    game_finished = True
                elif self.is_board_full(board):
                    self.print_board(board)
                    result = 'ничья'
                    print(f'\n🤝 {result}!')
                    self.save_game_result(result, size, game_mode, first_player)
                    game_finished = True
                else:
                    current_player = 'o' if current_player == 'x' else 'x'
            
            while True:
                answer = input('\nсыграем еще раз? (да/нет): ').lower().strip()
                if answer in ['да', 'д', 'yes', 'y']:
                    break
                elif answer in ['нет', 'н', 'no', 'n']:
                    print('спасибо за игру! до свидания!')
                    return
                else:
                    print('пожалуйста, введите "да" или "нет"!')

game = game()
game.play_game()