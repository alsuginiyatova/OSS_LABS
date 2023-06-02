#!/bin/bash

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S')]: $*" >&2
}

readinput() {
	local -n arr=$1
	arr+=("Справка" "Назад")
	select opt in "${arr[@]}"; do
	case $opt in
		Назад) return 0;;
		Справка) echo "Введите число, соответствующее опции из списка";;
		*)
			if [[ -z $opt ]]; then
				echo "Ошибка: введите число из списка" >&2
			else
				return $REPLY
			fi
			;;
	esac
	done
}

if [ "$EUID" -ne 0 ]; then
	echo "Не администратор"
	exit
fi

PS3=$'\n> '
options=(
	"Управление портами"
	"Управление файлами"
    "Управление переключателями"
	"Справка"
	"Выйти"
)

select opt in "${options[@]}"
do
	case $opt in
	"Управление портами")
        echo "Выберите интересующую функцию: "
		options2=( "изменить существующий порт службы" "добавить новый порт для службы" "вывести все службы")
        readinput options2
        res=$?
		[ $res == 0 ] && continue
		if [ $res == 1 ]; then
            read -p "Введите имя службы: " name
            if [ "$name" == "" ]; then
			    name="port_t"
		    fi
            echo "Список портов данной службы: "
            semanage port -l -n | grep $name
            read -p "Введите старый порт службы: " port
            if [ "$port" == "" ]; then
			    echo "номер порта не может быть пустым"
		    fi
            semanage port -d -t $name -p tcp $port
            [ $? -ne 0] && continue

            read -p "Введите новый порт службы: " newport
            if [ $newport == "" ]; then
			    echo "новый номер порта не может быть пустым"
		    fi
            semanage port -a -t $name -p tcp $newport
		    
        elif [ $res == 2 ]; then
            read -p "Введите имя службы: " name
            if [ "$name" == "" ]; then
			    echo "Имя службы не может быть пустым"
		    fi
            read -p "Введите новый порт для службы: " port
            if [ "$port" == "" ]; then
			    echo "номер порта не может быть пустым"
		    fi
            semanage port -a -t $name -p tcp $port
        else
            semanage port -l -n | cut -d" " -f1 | uniq -u | less
        fi
		;;

	"Управление файлами")
        options2=( "Переразметка каталога" "Запустить полную переразметку файловой системы при перезагрузке" "Изменить домен файла или каталога" )
		readinput options2
        res=$?
		[ $res == 0 ] && continue
		if [ $res == 1 ]; then
            read -p "введите имя каталога: " path
            if [ -d $filepath ]; then
				restorecon -Rvv "$path"
            else
                echo $path не является каталогом
            fi
        elif [ $res == 2 ]; then    
            touch /.autorelabel
        else
            read -p "Введите путь до файла/каталога: " filepath
			if [ "$filepath" == "" ]; then
				err "путь не может быть пустой"
				continue 
			fi
			if [ ! -е ]; then
				err "пути не существует"
				continue
            fi
            read -p "Введите новый домен: " newdomen
            semanage fcontext -a -t $newdomen "$path(/.*)?"
            [ $? -ne 0 ] && continue
            restorecon -Rv $path
        fi
        ;;

	"Управление переключателями")
		options2=("Вывести список переключателей" "Изменить переключатель" )
        readinput options2
        res=$?
		[ $res == 0 ] && continue
		if [ $res == 1 ]; then
            getsebool -a
        else
            readarray -t bools < <(getsebool -a | cut -d' ' -f1)
            readinput bools
            res=$?
            [ $res == 0 ] && continue
            bool=${bools[res - 1]}
            state=$(getsebool $bool | cut -d" " -f3)
            echo "текущее состояние: $state"
            read -p "переключить (y/n)? " answer
            if [ "$answer" == "y" ]; then
                newstate="off"
                [ "$state" == "off" ] && newstate="on"
                setsebool -P $bool $newstate
            fi
        fi
		;;
	"Справка")
		echo "Введите интересующую вас команду"
		;;
	"Выйти")
		break
		;;
	*) echo "Неправильная команда $REPLY";;
	esac
done
