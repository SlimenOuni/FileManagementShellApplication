#!/bin/sh

show_usage()
{
    echo 'disque.sh: [-h] [-j] [-s] [-p] [-l] [-v] [-m] [-g] chemin'
    exit 0
}

check_args()
{
    if ["$#" -ne 1]; then
        show_usage
        exit 0
    fi
}

help()
{
    if [ -a helpdisque.txt ]; then
        cat helpdisque.txt
    fi
}


find_files()
{
   if [[ $(find .  -size +100000c) ]]; then
        echo 'Files that are over 100KB in size :'
        find .  -size +100000c
    else
        echo 'No files found!!'
    fi
}


delete_file()
{
    filename=$1
    limit=100000
    size=$(stat -c %s $filename)
    if [ $size -gt $limit ]; then
        rm $1
        echo "Hurray!! File $1 has been removed successfully :D"
    else
        echo "Ohh!! cannot remove file $1 because size is under 100KB. :("
    fi
}

compress_file()
{
    filename=$1
    limit=100000
    size=$(stat -c %s $filename)
    if [ $size -gt $limit ]; then
        gzip $1
        echo "Hurray!! File $1 has been compressed successfully :D"
    else
        echo "Ohh!! cannot compress file $1 because size is under 100KB. :("
    fi
}

multiple_file_cmp_del()
{
    if [ $# -eq 0 ]; then
        echo "You have to pass at least one file to be deleted or compressed :D, Thank you."
    else
    echo "1-Delete files"
    echo "2-Compress files"
    read -p "You have chosen" c 
    case $c in
    1) echo "Deleting files..."
        for i in $*;do
            rm $i
        done;;
    2) echo "Compressing file..."
        for i in $*;do
            gzip $i
        done;;
    *) echo "Invalid choice";;
    esac
    fi 
}

get_version() 
{
    echo 'Authors : Slimen OUNI & Emna OUNI V0.0.1'
}

run_dialog(){
input=`yad --entry --title="File Management Application" --text="\n1- List file larger than 100KB.
 \n2- Delete a file its size exceeds 100KB. 
 \n3- Compress a file whose size exceeds 100KB. 
 \n4- Delete or compress one or more files.
 \n5-  Create deleted files log file.
 \n6-  Show detailed help.
 \n7-  Show author name and code version."--entry-label="Enter a number from 1 to 7"`

exval=$?
case $exval in
   0)
case $input in
        1)
               	find_files
                ;;
        2)
                echo "give file name ::"
                find_files
                read op 
                delete_file $op
                ;;
        3)
               echo "give file name ::"
                find_files
                read op
                compress_file $op 
                ;;
        4)
                echo "give files names to delete or compress ::"
                find_files
                read op
                multiple_file_cmp_del $op
                ;;
        5)
                
                ;;
        6)
                help
                ;;
        7)
                get_version
                ;;
        *)
               show_usage
                ;; 
  esac
;;
esac
}


show_menu_list()
{
    echo "1- List file larger than 100KB."
    echo "2- Delete a file its size exceeds 100KB."
    echo "3- Compress a file whose size exceeds 100KB."
    echo "4- Delete or compress one or more files."
    echo "5- Create deleted files log file."
    echo "6- Show detailed help."
    echo "7- Show author name and code version."
    echo "0- Exit"
}

menu()
{
    CHOISE=-1
    show_menu_list
    until [ $CHOISE -gt 0 ]
    do
        read -p "Choose an option from 0 to 7" choise
        case $choise in 
            1)
               	find_files
                ;;
            2)
                echo "give file name ::"
                find_files
                read op 
                delete_file $op
                ;;
            3)
                echo "give file name ::"
                find_files
                read op
                compress_file $op 
                ;;
            4)
                echo "give files names to delete or compress ::"
                find_files
                read op
                multiple_file_cmp_del $op
                ;;
            5)
                
                ;;
            6)
                help
                ;;
            7)
                get_version
                ;;
            
            *)
               show_usage
                ;; 
  esac
 done
}


run(){

case $1 in

        "-l")
                echo "List of files over 100kb :"
               	find_files
                ;;
        "-p")
                echo "Browse files to delete or compress that size exceed 100KB"
                find_files
                echo "give files names to delete or compress ::"
                read op
                multiple_file_cmp_del $op
                ;;
        "-s")
                echo "Delete a file that size exceed 100KB"
                find_files
                echo "give file name ::"
                read op 
                delete_file $op
                ;;
        "-c")
                echo "Compress a file that size exceed 100KB"
                find_files
                echo "give file name ::"
                read op
                compress_file 
                ;;
        "-j")
                echo "Create log file of deleted files"
                
                ;;
        "-v")
                echo "To display the name of the authors and the version of the code"
                get_version
                ;;
        "-h")
                echo "To display detailed help from a text file"
                help
                ;;
        "-m")
                echo "*************************Menu*************************"
                menu
                ;;
        "-g")
                echo "To display a textual menu and manage features in a GUI(Using YAD)."
                run_dialog
                ;;

        *)
               show_usage
               exit 1
                ;;
esac

}

run $1
exit 0