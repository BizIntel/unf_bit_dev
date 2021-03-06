﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРК".
// ОбщийМодуль.СПАРКРискиКлиентПовтИсп.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет возможность использования сервиса в соответствии с текущим
//  режимом работы и правами пользователя.
//
// Возвращаемое значение:
//	Булево - Истина - использование разрешено, Ложь - в противном случае.
//
Функция ИспользованиеРазрешено() Экспорт

	Возврат СПАРКРискиВызовСервера.ИспользованиеРазрешено();

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СправочникиКонтрагенты() Экспорт
	
	Возврат СПАРКРискиВызовСервера.СправочникиКонтрагенты();
	
КонецФункции

#КонецОбласти
