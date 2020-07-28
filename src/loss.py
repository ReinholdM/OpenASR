import torch
import torch.nn.functional as F


def cal_qua_loss(_number, number):
    qua_loss = torch.pow(_number - number, 2).sum()

    return qua_loss


def cal_ce_loss(logits, target_labels, target_paddings, label_smooth):
    losses = _compute_cross_entropy_losses(logits, target_labels, target_paddings)
    loss = losses.sum()
    if label_smooth > 0:
        loss = loss * (1-label_smooth) + _uniform_label_smooth(logits, target_paddings)*label_smooth

    return loss


def _uniform_label_smooth(logits, paddings):
    log_probs = F.log_softmax(logits, dim=-1)
    nlabel = log_probs.shape[-1]
    ent_uniform = -torch.sum(log_probs, dim=-1)/nlabel

    return torch.sum(ent_uniform*(1-paddings).float())


def _compute_cross_entropy_losses(logits, labels, paddings):
    B, T, V = logits.shape
    losses = F.cross_entropy(logits.contiguous().view(-1, V),
                             labels.contiguous().view(-1),
                             reduction="none").view(B, T) * (1-paddings).float()

    return losses
