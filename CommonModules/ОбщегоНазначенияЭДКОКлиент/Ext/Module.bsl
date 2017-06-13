﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность 
//             электронного документооборота с контролирующими органами". 
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Возвращает описание технических характеристик компьютера (только для Windows).
// 
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено           - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * СистемнаяИнформация - ФиксированнаяСтруктура - описание технических характеристик компьютера.
//        ** ИмяОС         - Строка - наименование операционной системы (например, Windows 7, Windows Server 2003 R2 и др.).
//        ** ВерсияОС      - Строка - версия операционной системы в формате РР.П. 
//        ** РазрядностьОС - Число - разрядность операционной системы (32 или 64).
//      * ОписаниеОшибки      - Строка - описание ошибки выполнения.
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура ПолучитьСистемнуюИнформацию(ОповещениеОЗавершении, ВыводитьСоообщения = Истина) Экспорт
	
	ОбщегоНазначенияЭДКОСлужебныйКлиент.ПолучитьСистемнуюИнформацию(ОповещениеОЗавершении, ВыводитьСоообщения);
	
КонецПроцедуры

// Выполняет установку криптопровайдера ViPNet CSP.
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено           - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ОписаниеОшибки      - Строка - описание ошибки выполнения.
//    
//   ВладелецФормы - УправляемаяФорма - форма, которая будет указана в качестве владельца.
//
Процедура УстановитьViPNetCSP(ОповещениеОЗавершении, ВладелецФормы) Экспорт
	
	ОбщегоНазначенияЭДКОСлужебныйКлиент.УстановитьViPNetCSP(ОповещениеОЗавершении, ВладелецФормы);
	
КонецПроцедуры

// Проверяет возможен ли конфликт установленных криптопровайдеров и при необходимости выдает предупреждение.
Процедура СообщитьПользователюОКонфликтеКриптопровайдеров() Экспорт
	
	ОбщегоНазначенияЭДКОСлужебныйКлиент.СообщитьПользователюОКонфликтеКриптопровайдеров();
	
КонецПроцедуры

#КонецОбласти
