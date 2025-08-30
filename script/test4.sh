 select choice in dog cat bird stop
 do
 case $choice in
 	dog) echo "A dog barks" ;;
 	cat) echo "A cat meows" ;;
 	bird) echo "A bird chirps" ;;
 	stop) break ;;
 	*)echo "Invalid choice" ;;
   esac
 done
