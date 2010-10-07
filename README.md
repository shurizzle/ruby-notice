Notice
======

You can use notice simply with function 'notice':
    notice('Testing') {
        sleep 2
        true
    }

It will notify status of the block, if the block returns nil or false it will
notify a fault, if not it will notify a success.

If you want to reuse a block you can simply write:
    notice('Testing')

Default block is:
    lamba { true }
