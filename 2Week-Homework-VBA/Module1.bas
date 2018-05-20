Attribute VB_Name = "Module1"
Sub Stocks_Easy_Solution()
    
    'Loop through all worksheets
    For Each ws In Worksheets:
        
        Lastrow = ws.Cells(Rows.Count, 1).End(xlUp).Row
        ws.Range("I1").Value = "Ticker"
        ws.Range("J1").Value = "Total Stock Volume"
    
        Dim Stock_Name As String
        Dim Stock_Volume As Double
        Stock_Volume = 0
        
        Dim Sum_Of_Ticker_Row As Integer
        Sum_Of_Ticker_Row = 2
    
        'Loop through each ticker
        For i = 2 To Lastrow
            'Check is still same ticker
            If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then
                'Set Ticker name
                Stock_Name = ws.Cells(i, 1).Value
                'Add Volume to the total
                Stock_Volume = Stock_Volume + ws.Cells(i, 7).Value
                
                'Display ticker name and final volume total to the table
                ws.Range("I" & Sum_Of_Ticker_Row).Value = Stock_Name
                ws.Range("J" & Sum_Of_Ticker_Row).Value = Stock_Volume
                
                'Reset the loop
                Sum_Of_Ticker_Row = Sum_Of_Ticker_Row + 1
                Stock_Volume = 0
            Else
                'If ticker is the same, just add the volume
                Stock_Volume = Stock_Volume + ws.Cells(i, 7).Value
            End If
        Next i
    Next ws
End Sub


        
