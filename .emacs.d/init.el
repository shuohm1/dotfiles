;; デフォルト作業ディレクトリを HOME に設定
(cd (getenv "HOME"))

;; ロードパス追加
(add-to-list 'load-path "~/.emacs.d/elisp")

;; 起動時のスプラッシュ画面を表示しない
(setq inhibit-startup-message t)

;; *scratch* の初期値
;(setq initial-scratch-message "")

;; ホスト名を取得
;; (http://qiita.com/j8takagi/items/504ccb86921695bdec13)
(defvar system-name-simple
  (replace-regexp-in-string "\\..*\\'" "" (system-name))
  "The simple host name of the machine Emacs is running on, which is without domain information.")

;; 起動時の表示位置とサイズ
(when (equal system-name-simple "LEVIATHAN")
  (load-file "~/.emacs.d/init-leviathan.el"))

;; タイトルバーに現在のファイル名のフルパスを表示
(when window-system
  (setq frame-title-format (format "%%f - emacs@%s" (system-name))))

;; 端末上の場合はメニューバーを非表示
(unless window-system
  (menu-bar-mode 0))
;; ツールバーを非表示
(tool-bar-mode 0)

;; タブバーモード
;; (http://www.emacswiki.org/emacs/tabbar.el)
(when window-system
  (require 'tabbar)
  (global-set-key [(control shift tab)] 'tabbar-backward)
  (global-set-key [(control tab)]       'tabbar-forward)
  (tabbar-mode t))

;; 透明度
(when window-system
  (set-frame-parameter nil 'alpha 90))
;; 透明度を変更するコマンド: M-x set-alpha
;; (http://qiita.com/marcy@github/items/ba0d018a03381a964f24)
(defun set-alpha (alpha-num)
  "set frame parameter 'alpha"
  (interactive "nAlpha: ")
  (set-frame-parameter nil 'alpha (cons alpha-num '(90))))

;; スクロールバー非表示
(scroll-bar-mode 0)
;; 行番号表示 (左)
(require 'linum)
(setq linum-format "%4d ")
(custom-set-faces
 '(linum ((((class color)
            (background light))
           (:background nil :foreground nil))
          (((class color)
            (background dark))
           (:background nil :foreground "yellow"))
          (t ())
          )))
(global-linum-mode t)
;; 行番号表示に遅延を入れる
;; (http://d.hatena.ne.jp/daimatz/20120215/1329248780)
(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
  (run-with-idle-timer 0.2 nil #'linum-update-current))
;; カーソルの位置が何行目かを表示する (下)
(line-number-mode t)
;; カーソルの位置が何文字目かを表示する (下)
(column-number-mode t)

;; デフォルト文字とカーソルの背景色/前景色
;; +++ 色の一覧: M-x list-colors-display
;; +++ フェイスの一覧: M-x list-faces-display
(custom-set-faces
 ; デフォルト文字
 '(default ((((class color)
              (background light))
             (:background "brightwhite" :foreground "black"))
            (((class color)
              (background dark)); emacs -rv で起動したときなど
             (:background nil :foreground "white"))
            (t ())
            ))
 ; カーソル
 '(cursor ((((class color)
             (background light))
            (:background nil))
           (((class color)
             (background dark))
            (:background nil))
           (t ())
           )))

;; 現在行をハイライト (重いからやめた)
;(global-hl-line-mode t)
;(custom-set-faces
; '(highlight ((((class color)
;                (background light))
;               (:background "gray90"))
;              (((class color)
;                (background dark))
;               (:background "gray10"))
;              (t ())
;              )))

;; 括弧の強調表示
(show-paren-mode t)
;(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(custom-set-faces
 '(show-paren-match ((((class color)
                       (background light))
                      (:background "#98FB98")) ; palegreen: #98FB98
                     (((class color)
                       (background dark))
                      (:background "#006400")) ; darkgreen: #006400
                     (t ())
                     )))

;; 選択範囲をハイライト
(transient-mark-mode t)
(custom-set-faces
 '(region ((t
            (:background "#1E90FF" :foreground "brightwhite") ; dodgerblue: #1E90FF
            ))))

;; ビープ音の代わりに画面をフラッシュさせる
;(setq visible-bell t)
;; ビープ音も画面フラッシュもしない
(setq ring-bell-function 'ignore)

;; バックアップファイル設定
(setq make-backup-files nil)
;(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)
(setq create-lockfiles nil)

;; 改行時自動インデントを無効にする
(electric-indent-mode 0)

;; tab 幅を 4 に設定
(setq-default tab-width 4)
;; Python Mode の tab 幅を 4 に設定
(add-hook 'python-mode-hook
          '(lambda()
             (setq indent-tabs-mode t)
             (setq indent-level 4)
             (setq python-indent 4)
             (setq tab-width 4)))

; 行移動を論理行にする
(setq line-move-visual nil)

;; Ctrl-H 2回でヘルプ表示の抑制 (?)
;(load "term/bobcat")
;(when (fboundp 'terminal-init-bobcat) (terminal-init-bobcat))

;; キーバインド
;; +++ global-set-key は define-key の wrapper
;; +++ eg: (global-set-key "\C-x\C-b" 'buffer-menu)
;; +++ "\C-*" でうまくいかないときは (kbd "C-*") を使う
;; カーソル移動 (vim風)
(define-key global-map "\C-h" 'backward-char) ; 元は delete-backward-char
(define-key global-map "\C-j" 'next-line)     ; 元は electric-newline-and-maybe-indent
(define-key global-map "\C-k" 'previous-line) ; 元は kill-line
(define-key global-map "\C-l" 'forward-char)  ; 元は recenter-top-bottom
;; カーソル移動で使ったキーの代替
;(define-key global-map "\C-b" 'backward-char) ; 元は backward-char
;(define-key global-map "\C-n" 'next-line)     ; 元は next-line
;(define-key global-map "\C-p" 'previous-line) ; 元は previous-line
;(define-key global-map "\C-f" 'forward-char)  ; 元は forward-char
;; バックスペース (delete-backward-char)
;; Ctrl + ? (Ctrl + Shift + /) は emacs の仕様上避けるべきらしい
;(define-key global-map "\C-?" nil)
(define-key global-map (kbd "C-S-h") 'delete-backward-char)
;(define-key global-map [backspace] 'backward-delete-char-untabify)
;; 改行およびインデント (electric-newline-and-maybe-indent)
(define-key global-map (kbd "C-S-j") 'electric-newline-and-maybe-indent)
;; 改行 (だけ)
;(define-key global-map "\C-m" 'newline)
;(define-key global-map [return] 'newline)
;; 1行削除 (kill-line)
;(define-key global-map "\C-xk" 'kill-line)
;(define-key global-map "\C-x\C-k" 'kill-line)
(define-key global-map (kbd "C-S-k") 'kill-line)
;; 現在行を画面の中央に (recenter-top-bottom)
(define-key global-map "\C-xl" 'recenter-top-bottom)
;(define-key global-map "\C-x\C-l" 'recenter-top-bottom)   ; line-to-top-of-window で使う
(define-key global-map (kbd "C-S-l") 'recenter-top-bottom)
;; 現在行を画面の一番上に
;; (http://www.yumi-chan.com/emacs/emacs_el_small.html#20)
(defun line-to-top-of-window ()
  "Move the line point is on to top of window."
  (interactive)
  (recenter 0))
(define-key global-map "\C-x\C-l" 'line-to-top-of-window)
;; 先頭/末尾へ移動 (beginning/end-of-buffer)
(define-key global-map (kbd "C-,") 'beginning-of-buffer)
(define-key global-map (kbd "C-<") 'beginning-of-buffer)
(define-key global-map (kbd "C-.") 'end-of-buffer)
(define-key global-map (kbd "C->") 'end-of-buffer)
;; 文字列置換
;(define-key global-map (kbd "M-%") 'query-replace) ; 都度問い合わせ置換
(define-key global-map (kbd "C-%") 'replace-string) ; 一斉置換
;; アンドゥ (undo)
(define-key global-map (kbd "C-/") 'undo)
(define-key global-map "\C-_" 'undo)
;(define-key global-map "\C-z" 'undo) ; 元は suspend-frame
;; バッファリスト (開く時にウィンドウを分割しない)
(define-key global-map "\C-xb" 'buffer-menu)
(define-key global-map "\C-x\C-b" 'buffer-menu)
;; 指定行にジャンプする (goto-line)
(define-key global-map "\C-xj" 'goto-line)
(define-key global-map "\C-x\C-j" 'goto-line)
;; リージョンをインデント (indent-region)
(define-key global-map "\C-ci" 'indent-region)
;; コメント (comment/uncomment-region)
(define-key global-map "\C-c;" 'comment-region)   ; リージョンをコメントアウト
(define-key global-map "\C-c:" 'uncomment-region) ; リージョンをコメント解除
;; 現在のバッファにあるすべての式を評価 (eval-buffer)
(define-key global-map [f12] 'eval-buffer)
;; リージョンにある式を評価 (eval-region)
;(define-key global-map [f11] 'eval-region)
;; バイナリモード
(define-key global-map "\C-x\M-f" 'hexl-find-file)

;; 環境変数 LANG
;(setenv "LANG" "ja_JP.UTF-8")
;; 言語環境
(set-language-environment "Japanese")
;; デフォルトの文字/改行コード
(prefer-coding-system 'utf-8-unix)
;(set-default-coding-systems 'utf-8-unix) ; 非推薦
;; ファイル名の文字コード (for Windows)
;(set-file-name-coding-system 'cp932)
;; キーボードの文字コード (for Windows)
;(set-keyboard-coding-system 'cp932)
;; ターミナルの文字コード (for Windows)
;(set-terminal-coding-system 'cp932)
;; その他の文字コード設定 (?)
;(setq locale-coding-system 'utf-8)
;(set-buffer-file-coding-system 'utf-8)
;(setq default-buffer-file-coding-system 'utf-8)
;(set-selection-coding-system 'utf-16le-dos)

;; フォント
;; !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
;; ！”＃＄％＆’（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯ
;; ＰＱＲＳＴＵＶＷＸＹＺ［￥］＾＿‘ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～
;; あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをん
;; 安以宇衣於加幾久計己左之寸世曽太知川天止奈仁奴祢乃波比不部保末美武女毛也由与良利留礼呂和為恵遠无
;; アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヲヱン
;; 阿伊宇江於加機久介己散之須世曽多千川天止奈仁奴祢乃八比不部保末三牟女毛也由與良利流礼呂和井恵乎尓
;(when (eq window-system 'w32)
;  (set-face-attribute 'default nil
;;                     :family "Consolas"
;                      :family "MeiryoKe_Gothic"
;                      :height 110)
;  (dolist (target '(japanese-jisx0212
;                    japanese-jisx0213-2
;                    japanese-jisx0213.2004-1
;                    katakana-jisx0201
;                    ))
;    (set-fontset-font (frame-parameter nil 'font)
;                      target
;                      (font-spec :family "MeiryoKe_Gothic" :size 16
;                                 :registry "unicode-bmp" :lang 'ja))))
;; 行間の大きさ
(setq-default line-spacing 0.1)

;; 空白文字の可視化
(require 'whitespace)
;; 可視化する空白文字の指定
(setq whitespace-style '(face                 ; 可視化を有効化
                         spaces space-mark    ; 空白
                         tabs tab-mark        ; タブ
                         space-before-tab     ; タブの前の空白
;                        space-after-tab      ; タブの後の空白
                         trailing             ; 行末の空白
                         newline newline-mark ; 改行
                         ))
;; whitespace-space の定義を変更 (半角・全角スペース)
(setq whitespace-space-regexp "\\([\u0020\u3000]+\\)") ; 元の定義は "\\( +\\)"
;; whitespace-space-after-tab の定義を変更 (タブの後ろにある1つ以上の半角スペース)
;; 元の定義は '("\t+\\(\\( \\{%d\\}\\)+\\)" . "\\(\t+\\) +")
(setq whitespace-space-after-tab-regexp '("\\(?:^\\|\t+\\)\\(\u0020+\\)."))
;; 可視化文字の指定
(setq whitespace-display-mappings
      '(;(space-mark ?\u0020 [?\uffee] [?\_])
        (space-mark ?\u3000 [?\u25a1] [?\_ ?\_])   ; 全角スペース
;       (newline-mark ?\n [?\u21b5 ?\n] [?\$ ?\n]) ; 改行
        (newline-mark ?\n [?\u00ac ?\n] [?\$ ?\n]) ; 改行
        ;; WARNING: the mapping of tab-mark has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        (tab-mark ?\t [?\u00bb ?\t] [?\\ ?\t]) ; タブ
        ))
;; 可視化フェイスの指定;
(custom-set-faces
 ; 全角スペース "　　　"
 '(whitespace-space ((((class color)
                       (background light))
                      (:background nil :foreground "#8FBC8F")) ; darkseagreen: #8FBC8F
                     (((class color)
                       (background dark))
                      (:background nil :foreground "#808000")) ; olive: #808000
                     (t ())
                     ))
 ; タブ
 '(whitespace-tab ((((class color)
                     (background light))
                    (:background nil :foreground "#8FBC8F")) ; darkseagreen: #8FBC8F
                   (((class color)
                     (background dark))
                    (:background nil :foreground "#808000")) ; olive: #808000
                   (t ())
                   ))
 ; タブの前の空白
 '(whitespace-space-before-tab ((((class color)
                                   (background light))
                                   (:background "#ffcccc" :foreground nil))
                                 (((class color)
                                    (background dark))
                                  (:background "#800000" :foregrouond nil)) ; maroon: #800000
                                  (t ())
                                 ))
 ; タブの後の空白
; '(whitespace-space-after-tab ((t (:background "#101000" :foreground nil))))
 ; 行末の空白
 '(whitespace-trailing ((((class color) 
                          (background light)) 
                         (:background "#cc0000" :foreground nil)) 
                        (((class color) 
                          (background dark)) 
                         (:background "#B22222" :foreground nil)) ; firebrick: #B22222
                        (t ()) 
                        )) 
 ; 改行
 '(whitespace-newline ((((class color)
                         (background light))
                        (:background nil :foreground "#2E8B57")) ; seagreen: #2E8B57
                       (((class color)
                         (background dark))
                        (:background nil :foreground "#808000")) ; olive: #808000
                       (t ())
                       ))
 )
;; 空白文字の可視化オン
(global-whitespace-mode t)

;; [EOF]
