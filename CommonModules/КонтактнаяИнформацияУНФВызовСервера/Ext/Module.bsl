﻿
#Область ПрограммныйИнтерфейс

// Если XMLСтрока еще не задана, то ОжидаемыйВид - обязательный параметр
//
Процедура УстановитьКомментарийКонтактнойИнформации(XMLСтрока, Комментарий, ОжидаемыйВид = Неопределено) Экспорт
	
	Если ПустаяСтрока(XMLСтрока) Тогда
		XMLСтрока = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению("", ОжидаемыйВид);
	КонецЕсли;
	
	УправлениеКонтактнойИнформацией.УстановитьКомментарийКонтактнойИнформации(XMLСтрока, Комментарий);
	
КонецПроцедуры

// Функция-обертка для вызова с клиента.
// Описание см. УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению()
Функция КонтактнаяИнформацияXMLПоПредставлению(Представление, ОжидаемыйВид) Экспорт
	
	Возврат УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Представление, ОжидаемыйВид);
	
КонецФункции

#КонецОбласти