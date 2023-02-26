def get_author_info():
    print("-*"*14+"\n") 
    return "Avijit Singh Jhyont", "9999999999"

#Global Variables
max1=0; posMax1=[0,0]; max2=0; posMax2=[0,0]; min1=12; posMin1=[0,0]; min2=12; posMin2=[0,0]; maximum=0; maxPos=[0,0]; minimum=12; minPos=[0,0]; stack_len=0; numFaceDown=-2; firstFacedownPos=[0,0]; secondFacedownPos=[0,0]; alreadyPairedUpCards=[] 


#Returns a lost of paired cards and their values. If a value comes in kitty or deck that already exists in this list, I choose it to increase changes of getting two pairs of same value
def find_Pairedup_cards(top_concealed, bottom_concealed):    
    global alreadyPairedUpCards, stack_len; stack_len=len(top_concealed); alreadyPairedUpCards=[]    
    for n in range(stack_len):  
        if(top_concealed[n]==bottom_concealed[n] and top_concealed[n]!='*'): alreadyPairedUpCards.append(top_concealed[n])                    
    return alreadyPairedUpCards


#Find the number of facedown cards left (x shows the first facedown card seen, which is useful in the strategy)
def Number_of_facedown_cards_left(top_concealed, bottom_concealed):
    global numFaceDown, firstFacedownPos, secondFacedownPos, stack_len; numFaceDown=0; firstFacedownPos=[0,0]; stack_len=len(top_concealed)
    for n in range(stack_len):  
        if(top_concealed[n]=='*'): 
            numFaceDown+=1 
            if numFaceDown==1: firstFacedownPos=[0,n]              
            if numFaceDown==2: secondFacedownPos=[0,n]              
        if(bottom_concealed[n]=='*'): 
            numFaceDown+=1 
            if numFaceDown==1: firstFacedownPos=[1,n]               
            if numFaceDown==2: secondFacedownPos=[1,n]            
    return numFaceDown, firstFacedownPos, secondFacedownPos


#Finding the maximum and minimum values of stack on table
def Maximum_and_minimum_value_cards_currently_in_stack(top_concealed, bottom_concealed,maximum, maxPos, minimum, minPos, stack_len): 
    global max1, posMax1, max2, posMax2, min1, posMin1, min2, posMin2 
    stack_len=len(top_concealed); max1=0; posMax1=[0,0]; max2=0; posMax2=[0,0]; min1=12; posMin1=[0,0]; min2=12; posMin2=[0,0]
    for n in range(stack_len):  
        if top_concealed[n] != '*' and top_concealed[n] != bottom_concealed[n]:
            if max1 < top_concealed[n]:     max1 = top_concealed[n]; posMax1=[0,n] 
            if min1 > top_concealed[n]:     min1 = top_concealed[n]; posMin1=[0,n] #Note: top-concealed cards are all in row 0

        if bottom_concealed[n] != '*' and top_concealed[n] != bottom_concealed[n]: 
            if max2 < bottom_concealed[n]:  max2 = bottom_concealed[n]; posMax2=[1,n] #Note that row comes first & bottom-concealed cards are all row 1
            if min2 > bottom_concealed[n]:  min2 = bottom_concealed[n]; posMin2=[1,n]
    
    #maximum & minimum value in my stack
    maximum = max(max1,max2); 
    if(maximum==max1): maxPos=posMax1
    else: maxPos=posMax2
    minimum = min(min1,min2); 
    if(minimum==min1): minPos=posMin1  
    else: minPos=posMin2
        
    return maximum, maxPos, minimum, minPos


#If more than 1 facedown cards still left
def numFacedown_cards_more_than_1(top_concealed, bottom_concealed, draws_left, current_card, maximum, maxPos, minimum, minPos, firstFacedownPos, secondFacedownPos, stack_len):
    row=int(0); column=int(0)
    for n in range(stack_len):             
        if top_concealed[n]!='*' and top_concealed[n]!=bottom_concealed[n] and top_concealed[n]==current_card and bottom_concealed[n]!=-5:         
            row=1; column=n; break
        if bottom_concealed[n]!='*' and top_concealed[n]!=bottom_concealed[n] and bottom_concealed[n]==current_card and top_concealed[n]!=-5:            
            row=0; column=n; break                                            
        else:                                    
            if top_concealed[firstFacedownPos[1]]==-5 or bottom_concealed[firstFacedownPos[1]]==-5: row=secondFacedownPos[0]; column=secondFacedownPos[1]           
            else: row=firstFacedownPos[0]; column=firstFacedownPos[1]           
    if current_card==-5: row=secondFacedownPos[0]; column=secondFacedownPos[1] #maybe take this stmt  out of the for loop altogether
    return row,column
    

#If only 1 facedown card left
def numFacedown_cards_equal_1(top_concealed,bottom_concealed,draws_left, current_card, maximum, maxPos, minimum, minPos, firstFacedownPos,secondFacedownPos, stack_len):  
    row=int(-1); column=int(-1)  

    #trying to pair up the current_card with a card in stack    
    for n in range(stack_len):        
        if top_concealed[n]!='*' and bottom_concealed[n]!='*' and top_concealed[n]!=bottom_concealed[n] and top_concealed[n]==current_card:         
            row=1; column=n; break
        if bottom_concealed[n]!='*' and bottom_concealed[n]!='*' and top_concealed[n]!=bottom_concealed[n] and bottom_concealed[n]==current_card:            
            row=0; column=n; break                          

    #if failed to pair up above, trying to replace max-value-unpaired-stack_Card with current_card                               
    if(row==-1 or column==-1): 
        if maximum>0: row=maxPos[0]; column=maxPos[1];  
        if maximum<=0: row=firstFacedownPos[0]; column=firstFacedownPos[1]
        if (row==-1 or column==-1) and draws_left<=1:
            if(current_card<5): row=firstFacedownPos[0]; column=firstFacedownPos[1] 
            else: row=maxPos[0]; column=maxPos[1]
    if(row==-1 or column==-1): row=maxPos[0]; column=maxPos[1]
    return row,column


def choose_drawing_action(top_concealed, bottom_concealed, draws_left, kitty_card):
    action='d'; global stack_len, alreadyPairedUpCards; stack_len=len(top_concealed) #redefining stack_len value
    alreadyPairedUpCards = find_Pairedup_cards(top_concealed, bottom_concealed)
    for n in range(stack_len):                
        if top_concealed[n]!='*' and top_concealed[n]!=bottom_concealed[n] and top_concealed[n]==kitty_card and bottom_concealed[n]!= -5: action='k'; break
        if bottom_concealed[n]!='*' and top_concealed[n]!=bottom_concealed[n] and bottom_concealed[n]==kitty_card and top_concealed[n]!= -5: action='k'; break    
    if kitty_card==-5 or kitty_card==0: action='k'    
    if kitty_card in alreadyPairedUpCards: action='k'
    print('Value of Kitty Card:',kitty_card); 
    if action=='k': print('\tCard Chosen==>>Kitty_card')
    else: print('\tForgo Kitty_card, turn a facedown card')    
    return action


# Choose the replacement action for the current card. The return value of this function must be a triple of the form (action, row, column) 
def choose_replacement_action(top_concealed, bottom_concealed, draws_left, current_card):
    global numFaceDown, firstFacedownPos, secondFacedownPos, maximum, maxPos, minimum, minPos, stack_len
    action = "r"; row=int(0); column=int(0); stack_len=len(top_concealed)    
    #calculating number facedown cards and their positions
    numFaceDown, firstFacedownPos, secondFacedownPos = Number_of_facedown_cards_left(top_concealed, bottom_concealed)    

    #calculating the max&min values in the stack and their positions
    maximum, maxPos, minimum, minPos = Maximum_and_minimum_value_cards_currently_in_stack(top_concealed, bottom_concealed,maximum, maxPos, minimum, minPos, stack_len)

    #Strategy based on numFaceDown Cards left
    if( numFaceDown>1): 
        row, column = numFacedown_cards_more_than_1(top_concealed, bottom_concealed, draws_left, current_card, maximum, maxPos, minimum, minPos, firstFacedownPos, secondFacedownPos, stack_len)
    elif(numFaceDown<=1):         
        row, column = numFacedown_cards_equal_1(top_concealed, bottom_concealed, draws_left, current_card, maximum, maxPos, minimum, minPos, firstFacedownPos,secondFacedownPos, stack_len)

    #Displaying the result of each Draw in each Round    
    print("# Draws Left in the Round: ",draws_left)
    print('CARD CHOSEN=> ROW:',str(row),' and column:',str(column)) #comparing values based in strategy vs values given by code
    action_verb = "replace" if action in "rR" else "turn over"    
    print('-'*100)
    print('ROW/COLUMN\t0\t1\t2\t3\t4\t5\t6\t7\t8\t9 ')
    print('-'*100)
    print('0:\t\t',end="")
    for n in range(stack_len): print(top_concealed[n],end="\t")
    print("\n")
    print('1:\t\t',end="")    
    for n in range(stack_len): print(bottom_concealed[n],end="\t")
    print('\n'+'-'*100)
    print('#'*100+'\n\n')
    
    return action, row, column

