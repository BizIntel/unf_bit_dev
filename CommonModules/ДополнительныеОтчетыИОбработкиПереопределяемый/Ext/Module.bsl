﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет разделы, в которых доступна команда вызова дополнительных обработок.
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных обработок.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для рабочего стола.
//
// Описание:
//   В Разделы необходимо добавить метаданные тех разделов,
//   в которых размещены команды вызова.
//
//   Для рабочего стола вместо Метаданных необходимо добавлять.
//   ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола().
//
Процедура ОпределитьРазделыСДополнительнымиОбработками(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.МаркетингИПродажи);
	Разделы.Добавить(Метаданные.Подсистемы.ЗапасыИЗакупки);
	Разделы.Добавить(Метаданные.Подсистемы.Работы);
	Разделы.Добавить(Метаданные.Подсистемы.КомплектацияИПроизводство);
	Разделы.Добавить(Метаданные.Подсистемы.ДенежныеСредства);
	Разделы.Добавить(Метаданные.Подсистемы.ЗарплатаИПерсонал);
	Разделы.Добавить(Метаданные.Подсистемы.Компания);
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных отчетов.
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных отчетов.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для рабочего стола.
//
// Описание:
//   В Разделы необходимо добавить метаданные тех разделов, 
//   в которых размещены команды вызова.
//
//   Для рабочего стола вместо Метаданных необходимо добавлять.
//   ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола().
//
Процедура ОпределитьРазделыСДополнительнымиОтчетами(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.МаркетингИПродажи);
	Разделы.Добавить(Метаданные.Подсистемы.ЗапасыИЗакупки);
	Разделы.Добавить(Метаданные.Подсистемы.Работы);
	Разделы.Добавить(Метаданные.Подсистемы.КомплектацияИПроизводство);
	Разделы.Добавить(Метаданные.Подсистемы.ДенежныеСредства);
	Разделы.Добавить(Метаданные.Подсистемы.ЗарплатаИПерсонал);
	Разделы.Добавить(Метаданные.Подсистемы.Компания);
	
КонецПроцедуры

#КонецОбласти