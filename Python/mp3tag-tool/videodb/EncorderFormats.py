import logging
import re

logger = logging.getLogger(__name__)


def getNearestValue(list, num):
    # print("getNearestValue():{num}, {list}".format(num=num, list=sorted(list)))
    prev = min(list)
    for i in sorted(list):
        if num < i:
            return prev
        prev = i
    return max(list)


def xvformats_digit(text):
    logger.debug("xvformats_digit():text='{text}'".format(text=text))
    pattern = re.match(r'(.*) \[(.*)\]', text)
    if pattern is not None:
        target_format = pattern.group(1)
        formats = pattern.group(2)
        formats_list = eval("[{formats}]".format(formats=formats))
        formats_dict = dict()
        for i in formats_list:
            pattern = re.match(r'hls-(.*)p', i)
            if pattern is not None:
                formats_dict[i] = int(pattern.group(1))
        if len(formats_dict) == 0:
            formats_dict['mp4-low'] = 120
            formats_max = 240
        else:
            formats_dict['mp4-low'] = min(formats_dict.values())
            formats_max = max(formats_dict.values())
        if formats_max > 480:
            formats_dict['mp4-high'] = getNearestValue(formats_dict.values(), 480)
        else:
            formats_dict['mp4-high'] = formats_max
        # print(formats_dict)
        return formats_dict.get(target_format)


def conv_encoder_settings_digit(encoder_settings):
    encoder_settings_simple = conv_simple_encoder_settings(encoder_settings)
    result = encoder_settings_simple
    logger.debug('conv_encoder_settings_digit():encoder_settings={encoder_settings}'.format(encoder_settings=encoder_settings, result=result))
    for i in range(1):
        pattern = re.match(r'(.*) \[.*\]', encoder_settings)
        if pattern is not None:
            result = xvformats_digit(encoder_settings)
            break
        pattern = re.match(r'hls-(.*)[p]', encoder_settings_simple)
        if pattern is not None:
            result = int(pattern.group(1))
            break
        pattern = re.match(r'(.*)p', encoder_settings_simple)
        if pattern is not None:
            result = pattern.group(1)
            break
    if str(result).isdigit() is False:
        result = 0
    logger.debug('conv_encoder_settings_digit():return {result}: {encoder_settings}'.format(encoder_settings=encoder_settings, result=result))
    return int(result)


def conv_simple_encoder_settings(text):
    result = text
    for i in range(1):
        pattern = re.match(r'(.*) \[.*\]', text)
        if pattern is not None:
            pattern2 = re.match(r'mp4-(.*)', pattern.group(1))
            if pattern2 is not None:
                result = str(xvformats_digit(text)) + 'p'
            else:
                result = pattern.group(1)
            break
        pattern = re.match(r'(.*) - (.*) \((.*)\)\+(.*) - (.*) \((.*)\)', text)
        if pattern is not None:
            result = pattern.group(3)
            break
        pattern = re.match(r'(.*) - (.*p)', text)
        if pattern is not None:
            result = pattern.group(2)
            break
        pattern = re.match(r'(.*p) - (.*)', text)
        if pattern is not None:
            result = pattern.group(1)
            break
    return result


class EncorderFormat:
    formats_dict = dict()
    formats_max = 0
    def __init__(self, text):
        self.logger = logging.getLogger(__name__)
        self.formats = text
        self.simple_formats = conv_simple_encoder_settings(text)
        self.height = conv_encoder_settings_digit(text)
        self.logger.debug("EncorderFormat.__init__():text={text}, height={height}".format(text=text, height=self.height))
        self.max_quality_xv()

    def max_quality_xv(self):
        pattern = re.match(r'(.*) \[(.*)\]', self.formats)
        if pattern is not None:
            target_format = pattern.group(1)
            formats = pattern.group(2)
            formats_list = eval("[{formats}]".format(formats=formats))
            self.formats_dict = dict()
            for i in formats_list:
                pattern = re.match(r'hls-(.*)p', i)
                if pattern is not None:
                    self.formats_dict[i] = int(pattern.group(1))

            if len(self.formats_dict) == 0:
                self.formats_dict['mp4-low'] = 250
                self.formats_max = 240
                self.formats_min = 120
            else:
                self.formats_dict['mp4-low'] = min(self.formats_dict.values())
                self.formats_max = max(self.formats_dict.values())
                self.formats_min = min(self.formats_dict.values())
            if self.formats_max > 480:
                self.formats_dict['mp4-high'] = getNearestValue(self.formats_dict.values(), 480)
            else:
                self.formats_dict['mp4-high'] = self.formats_max
            # print(formats_dict)
            return self.formats_dict.get(target_format)

    def compare(self, text):
        return self.compare_encoder_settings(self.formats, text)

    def isBetterQuality(self, text):
        quality = conv_encoder_settings_digit(text)
        self.logger.debug("isBetterQuality():self={self},old_quality={quality}".format(self=self.height, quality=quality))
        if quality > self.height:
            return True
        return False

    def compare_encoder_settings(self, target):
        target_quality = conv_encoder_settings_digit(target)
        self.logger.debug("compare_encoder_settings():target={target}, height={height}, target_quality={target_quality}".format(target=target, height=self.height, target_quality=target_quality))
        if self.height >= target_quality:
            return self.formats
        if self.formats_max is not None:
            if target_quality > self.formats_max:
                return "hls-{res}p".format(res=self.formats_max)
        return target

    ENCODER_SETTINGS_RESOLUTION = dict()
