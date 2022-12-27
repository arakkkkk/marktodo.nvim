# Marktodo
# [todotxt](https://ericasadun.com/2019/11/13/lightweight-to-do-list-formatting/) with neovim!!
You can search todo written by [todotxt](https://ericasadun.com/2019/11/13/lightweight-to-do-list-formatting/) format from alll files in your current directory.

## screenshots

## Instration
Using packer
```
use 'arakkkkk/marktodo.nvim'
use 'nvim-telescope/telescope.nvim'
```

## Usage

### Create ToDo
```md
1---- 2-- 3--------- 4--------- 5-----------------------------------------------------
- [x] (A) 2022-12-27 2022-12-26 sample todo @context +Project due:2022-12-27 tag:value
                                            6------- 7------- 8------------- 8--------
```
1. Marktodo Picker
2. Priority (Optional)
3. Completion Date (Optional)
4. Creation Date (Optional)
5. Description
6. Context Tag (Optional)
7. Project Tag (Optional)
8. Special key/value tag (Optional)

## Search todo with nvim-telescope
```
use({
	"/arakkkkk/marktodo.nvim",
	config = function()
		require("marktodo").setup()
	end,
})
```

### Issues
- [x] todoparser
- [x] todofinder
- [x] cmp
- [ ] todoevents
